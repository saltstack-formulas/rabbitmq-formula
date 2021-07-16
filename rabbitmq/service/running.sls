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

    {%- for name, node in salt["pillar.get"]("rabbitmq:nodes", {}).items() %}
        {%- if 'service' in node and node.service %}

rabbitmq-service-running-directory-{{ name }}:
  file.directory:
    - name: {{ rabbitmq.dir.data }}/{{ name }}
    - user: rabbitmq
    - group: rabbitmq
    - makedirs: true
    - dir_mode: '0755'

rabbitmq-service-running-managed-{{ name }}:
  file.managed:
    - name: {{ rabbitmq.dir.service }}/rabbitmq-server-{{ name }}.service
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
        name: {{ name }}
        workdir: {{ rabbitmq.dir.data }}/{{ name }}
        nodeport: {{ null if 'nodeport' not in node else node.nodeport }}
        distport: {{ null if 'distport' not in node else node.distport }}
        nodename: {{ node.user }}
        mnesia_dir: {{ rabbitmq.dir.data }}/{{ name }}
    - watch_in:
      - cmd: rabbitmq-service-running-daemon-reload

            {%- if grains.os_family == 'RedHat' %}

rabbitmq-service-running-managed-{{ name }}-limits:
  file.managed:
    - name: /etc/systemd/system/rabbitmq-server-{{ name }}.service.d/limits.conf
    - user: root
    - group: root
    - makedirs: true
    - contents:
      - [Service]
      - LimitNOFILE=infinity
      - TimeoutSec=150
    - require_in:
      - service: rabbitmq-service-running-service-running-{{ name }}

            {%- endif %}

rabbitmq-service-running-service-running-{{ name }}:
  service.running:
    - name: rabbitmq-server-{{ name }}
    - retry: {{ rabbitmq.retry_option|json }}
    - enable: True
    - watch:
      - sls: {{ sls_config_file }}
    - onfail_in:
      - cmd: rabbitmq-service-running-service-running-{{ name }}
    - require:
      - file: rabbitmq-service-running-directory-{{ name }}
      - file: rabbitmq-service-running-managed-{{ name }}
  cmd.run:
    - names:
      - journalctl -xe -u {{ rabbitmq.service.name }} || true

        {%- endif %}
    {%- endfor %}

rabbitmq-service-running-daemon-reload:
  cmd.run:
    - name: systemctl daemon-reload
