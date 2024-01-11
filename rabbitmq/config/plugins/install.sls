# -*- coding: utf-8 -*-
# vim: ft=sls
---
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}
{%- set sls_service_running = tplroot ~ '.service.running' %}

include:
  - {{ sls_service_running }}

    {%- for name, node in rabbitmq.nodes.items() %}
        {%- if 'plugins' in node and node.plugins is iterable and node.plugins is not string %}
            {%- for plugin in node.plugins %}

rabbitmq-config-plugins-enabled-{{ name }}-{{ plugin }}:
  cmd.run:
    - name: /usr/sbin/rabbitmq-plugins --node {{ name }} enable {{ plugin }} || true
    - runas: root
    - unless: /usr/sbin/rabbitmq-plugins --node {{ name }} is_enabled {{ plugin }}
    - onchanges_in:
      - cmd: rabbitmq-service-running-daemon-reload
    - watch_in:
      - service: rabbitmq-service-running-service-running-{{ name }}

                {%- if plugin == 'rabbitmq_management' %}

rabbitmq-config-plugins-{{ name }}-rabbitmqadmin-install:
  cmd.run:
    {%- set rabbitmqadmin = "/usr/local/sbin/rabbitmqadmin" %}
    - name: >
        curl -k -L http://127.0.0.1:15672/cli/rabbitmqadmin -o {{ rabbitmqadmin }}
        && chown root:{{ rabbitmq.rootgroup }} {{ rabbitmqadmin }}
        && chmod 755 {{ rabbitmqadmin }}
    - unless: test -x {{ rabbitmqadmin }}
    - onlyif: /usr/sbin/rabbitmq-plugins --node {{ name }} is_enabled rabbitmq_management
    - require:
      - sls: {{ sls_service_running }}

                {%- endif %}
            {%- endfor %}
        {%- endif %}
    {%- endfor %}
