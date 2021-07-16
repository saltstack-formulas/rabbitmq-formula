# -*- coding: utf-8 -*-
# vim: ft=sls
---
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}
{%- set sls_service_running = tplroot ~ '.service.running' %}

include:
  - {{ sls_service_running }}

    {%- for name, node in salt["pillar.get"]("rabbitmq:nodes", {}).items() %}
        {%- if 'plugins' in node and node.plugins is iterable and node.plugins is not string %}
            {%- for plugin in node.plugins %}

rabbitmq-config-plugins-enabled-{{ plugin }}:
  cmd.run:
    - name: /usr/sbin/rabbitmq-plugins --node {{ name }} enable {{ plugin }}
    - runas: rabbitmq
    - onlyif: test -x /usr/sbin/rabbitmqctl
    - watch_in:
      - sls: {{ sls_service_running }}

            {%- endfor %}
        {%- endif %}
    {%- endfor %}
