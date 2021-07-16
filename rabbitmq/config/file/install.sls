# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

rabbitmq-config-file-file-managed:

    {%- if salt['pillar.get']('rabbitmq:config:context', None) %}
  file.managed:
    - name: {{ rabbitmq.config.name }}
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
        config: {{ rabbitmq.config.context | json }}

    {%- else %}
  test.show_notification:
    - name: Skipping config file management
    - text: |
        No configuration data provided in the pillar data

    {%- endif %}
    {%- if salt['pillar.get']('rabbitmq:env:context', None) %}

rabbitmq-config-env-file-managed:
  file.managed:
    - name: {{ rabbitmq.env.name }}
    - source: {{ files_switch(['config.tmpl'],
                              lookup='rabbitmq-config-env-file-managed'
                 )
              }}
    - mode: 644
    - user: root
    - group: {{ rabbitmq.rootgroup }}
    - makedirs: True
    - template: jinja
    - context:
        env: {{ rabbitmq.env.context | json }}

    {%- endif %}
    {%- for filename, info in salt["pillar.get"]("rabbitmq:config_files", {}).items() %}
        {%- set source = info['source'] %}

rabbitmq-config-{{ filename }}-file-managed:
  # depreciated
  file.managed:
    name: /etc/rabbitmq/{{ filename }}
        {%- if source.startswith('salt://') %}
    - source: {{ source }}
        {%- else %}
    - source: salt://{{ tplroot }}/{{ source }}
        {% endif %}
    - template: jinja
    - context: {{ info.get('context', {})|json }}

    {% endfor %}
    {%- if grains.os_family == 'RedHat' %}

rabbitmq-config-file-file-managed-limits:
  file.managed:
    - name: /etc/systemd/system/{{ rabbitmq.service.name }}.service.d/limits.conf
    - user: root
    - group: root
    - makedirs: true
    - contents:
      - [Service]
      - LimitNOFILE=infinity
      - TimeoutSec=150
    - require_in:
      - service: rabbitmq-service-running-service-running

        {%- if rabbitmq.env.locale_all %}
  environ.setenv:
    - name: LC_ALL
    - value: {{ rabbitmq.env.locale_all }}
    - update_minion: True
    - require_in:
      - service: rabbitmq-service-running-service-running
        {%- endif %}
    {%- endif %}
