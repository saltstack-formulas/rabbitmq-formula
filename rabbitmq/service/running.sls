# -*- coding: utf-8 -*-
# vim: ft=sls
---
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_file = tplroot ~ '.config.file.install' %}
{%- set sls_config_user = tplroot ~ '.config.user.install' %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

include:
  - {{ sls_config_file }}
  - {{ sls_config_user }}

rabbitmq-service-running-service-directory:
  file.directory:
    - name: {{ rabbitmq.dir.data }}
    - user: rabbitmq
    - group: rabbitmq
    - dir_mode: '0755'

    {%- if rabbitmq.cluster %}
        {%- for name, cluster in salt["pillar.get"]("rabbitmq:cluster", {}).items() %}

rabbitmq-service-running-workdir-{{ name }}:
  file.directory:
    - name: {{ rabbitmq.dir.data }}/{{ name }}
    - user: rabbitmq
    - group: rabbitmq
    - dir_mode: '0755'

rabbitmq-service-running-managed-{{ name }}:
  file.managed:
    - name: {{ rabbitmq.dir.service }}/{{ rabbitmq.service.name }}-{{ name }}.service
    - source: {{ files_switch(['systemd.ini.jinja'],
                              lookup='rabbitmq-service-running-managed-' ~ name
                 )
              }}
    - mode: '0644'
    - user: rabbitmq
    - group: {{ rabbitmq.rootgroup }}
    - makedirs: True
    - template: jinja
    - context:
        name: {{ cluster.user }}
        workdir: {{ rabbitmq.dir.data }}/{{ name }}
        nodeport: {{ cluster.nodeport }}
        distport: {{ cluster.nodeport + 20000 }}
        nodename: {{ cluster.user }}
        start_args: -rabbitmq_management listener [{port,{{ cluster.nodeport + 10000 }}}]
        mnesia_dir: {{ rabbitmq.dir.data }}/{{ name }}
    - watch_in:
      - cmd: rabbitmq-service-running-daemon-reload

rabbitmq-service-running-service-running-{{ name }}:
  service.running:
    - name: {{ rabbitmq.service.name }}-{{ name }}
    - retry: {{ rabbitmq.retry_option|json }}
    - enable: True
    - watch:
      - sls: {{ sls_config_file }}
    - onfail_in:
      - cmd: rabbitmq-service-running-service-running-{{ name }}
    - require:
      - file: rabbitmq-service-running-workdir-{{ name }}
      - file: rabbitmq-service-running-managed-{{ name }}
      - cmd: rabbitmq-service-running-daemon-reload
  cmd.run:
    - names:
      - journalctl -xe -u {{ rabbitmq.service.name }} || true

rabbitmq-service-running-{{ name }}-join-{{ cluster.host }}:
  file.managed:
    - name: {{ rabbitmq.dir.data }}/{{ name }}/.erlang.cookie
    - contents: {{ cluster.erlang_cookie }}
    - mode: 400
    - user: rabbitmq
    - group: {{ rabbitmq.rootgroup }}
    - makedirs: True
    - watch_in:
      - service: rabbitmq-service-running-service-running-{{ name }}

            {%- if 'host' in grains and grains.host not in cluster.host %}

  rabbitmq_cluster.joined:
    - name: {{ name }}
    - user: {{ cluster.user }}
    - host: localhost
    - runas: {{ cluster.runas }}
    - require:
      - file: rabbitmq-service-running-{{ name }}-join-{{ cluster.host }}
      - sls: {{ sls_config_user }}
      - service: rabbitmq-service-running-service-running-{{ name }}

            {%- endif %}
        {%- endfor %}
    {%- else %}

rabbitmq-service-running-service-running:
  service.running:
    - name: {{ rabbitmq.service.name }}
    - retry: {{ rabbitmq.retry_option|json }}
    - enable: True
    - watch:
      - sls: {{ sls_config_file }}
    - onfail_in:
      - cmd: rabbitmq-service-running-service-running
  cmd.run:
    - names:
      - journalctl -xe -u {{ rabbitmq.service.name }} || true

    {%- endif %}

rabbitmq-service-running-daemon-reload:
  cmd.run:
    - name: systemctl daemon-reload
