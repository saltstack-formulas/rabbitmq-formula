# -*- coding: utf-8 -*-
# vim: ft=sls
---
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}
{%- set sls_service_running = tplroot ~ '.service.running' %}

include:
  - {{ sls_service_running }}

    {%- for name, node in salt["pillar.get"]("rabbitmq:nodes", {}).items() %}
        {%- if 'config' in node and node.config is mapping %}

rabbitmq-config-files-managed-{{ name }}:
  file.managed:
    - name: '{{ rabbitmq.dir.config }}/{{ name }}/rabbitmq-server-{{ name }}.conf'
    - source: {{ files_switch(['config.tmpl'],
                              lookup='rabbitmq-config-files-managed-' ~ name
                 )
              }}
    - mode: 644
    - user: root
    - group: {{ rabbitmq.rootgroup }}
    - makedirs: True
    - template: jinja
    - context:
        config: {{ node.config | json }}
    - require_in:
      - sls: {{ sls_service_running }}
    - watch_in:
      - sls: {{ sls_service_running }}

        {%- endif %}
    {%- endfor %}

    {%- if 'environ' in rabbitmq and rabbitmq.environ %}

rabbitmq-config-files-environ-managed:
  file.managed:
    - name: {{ rabbitmq.dir.config }}/rabbitmq-env.conf
    - source: {{ files_switch(['config.tmpl'],
                              lookup='rabbitmq-config-files-environ-managed'
                 )
              }}
    - mode: 644
    - user: root
    - group: {{ rabbitmq.rootgroup }}
    - makedirs: True
    - template: jinja
    - context:
        env: {{ rabbitmq.environ | json }}

    {%- endif %}
    {%- if grains.os_family == 'RedHat' and rabbitmq.environ.locale_all %}

rabbitmq-config-files-environ-setenv:
  environ.setenv:
    - name: LC_ALL
    - value: {{ rabbitmq.environ.locale_all }}
    - update_minion: True

    {%- endif %}

