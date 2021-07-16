# -*- coding: utf-8 -*-
# vim: ft=sls
---
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}
{%- set sls_service_running = tplroot ~ '.service.running' %}

include:
  - {{ sls_service_running }}

    {%- for name, node in salt["pillar.get"]("rabbitmq:nodes", {}).items() %}
        {%- if 'config' in node and node.config is mapping %}

rabbitmq-config-files-managed-{{ name }}:
  file.managed:
    - name: {{ rabbitmq.dir.config }}/{{ {{ rabbitmq.config.name }}
    - source: {{ files_switch(['config.tmpl'],
                              lookup='rabbitmq-config-file-file-managed'
                 )
              }}
    - mode: 644
    - user: root
    - group: {{ rabbitmq.rootgroup }}
    - makedirs: True
    - template: jinja
    - context:
        config: {{ node.config | json }}

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
    {%- if grains.os_family == 'RedHat' and rabbitmq.locale_all %}

rabbitmq-config-files-environ-setenv:
  environ.setenv:
    - name: LC_ALL
    - value: {{ rabbitmq.env.locale_all }}
    - update_minion: True

        {%- endif %}
    {%- endif %}

