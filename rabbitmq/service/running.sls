# -*- coding: utf-8 -*-
# vim: ft=sls
---
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_files = tplroot ~ '.config.files.install' %}
{%- set sls_config_users = tplroot ~ '.config.users.install' %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

include:
  - {{ sls_config_files }}
  - {{ sls_config_users }}

    {%- for name, node in rabbitmq.nodes.items() %}
        {%- if 'service' in node and node.service %}
            {%- set svcname = 'rabbitmq-server' %}
            {%- if name != 'rabbit' %}
                {%- set svcname = svcname ~ '-' ~ name %}
            {%- endif %}

rabbitmq-service-running-directory-{{ name }}:
  file.directory:
    - name: {{ rabbitmq.dir.data }}/{{ name }}
    - user: rabbitmq
    - group: rabbitmq
    - makedirs: true
    - dir_mode: '0755'

rabbitmq-service-running-managed-{{ name }}:
  file.managed:
    - name: '{{ rabbitmq.dir.service }}/{{ svcname }}.service'
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
        nodeport: {{ '' if 'nodeport' not in node else node.nodeport }}
        distport: {{ '' if 'distport' not in node else node.distport }}
        nodename: {{ name }}
        mnesia_dir: {{ rabbitmq.dir.data }}/{{ name }}
        cfgfile: {{ rabbitmq.dir.config }}/{{ name }}/rabbitmq-server.conf
    - watch_in:
      - cmd: rabbitmq-service-running-daemon-reload
    - require_in:
      - service: rabbitmq-service-running-service-running-{{ name }}

                {%- if grains.os_family == 'RedHat' %}
rabbitmq-service-running-managed-{{ name }}-limits:
  file.managed:
    - name: '/etc/systemd/system/{{ svcname }}.service.d/limits.conf'
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
    - name: {{ svcname }}
    - retry: {{ rabbitmq.retry_option|json }}
    - enable: True
    - onfail_in:
      - cmd: rabbitmq-service-running-service-running-{{ name }}
    - require:
      - cmd: rabbitmq-service-running-daemon-reload
      - file: rabbitmq-service-running-directory-{{ name }}
      - file: rabbitmq-service-running-managed-{{ name }}
  cmd.run:
    - names:
      - journalctl -xe -u {{ svcname }} || true

        {%- endif %}
    {%- endfor %}

rabbitmq-service-running-daemon-reload:
  cmd.run:
    - name: systemctl daemon-reload
