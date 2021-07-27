# -*- coding: utf-8 -*-
# vim: ft=sls
---
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}
{%- set sls_service_running = tplroot ~ '.service.running' %}

include:
  - {{ sls_service_running }}

    {%- for name, node in rabbitmq.nodes.items() %}
        {%- if 'params' in node and node.params is mapping %}
            {%- for param, items in node.params.items() %}

rabbitmq-config-params-present-{{ name }}-{{ param }}:
  cmd.run:
    - name: /usr/sbin/rabbitmqctl --node {{ name }} {{ items.action }} {{ items.args|join(' ') }}
    - onlyif: test -x /usr/sbin/rabbitmqctl
    - require:
      - sls: {{ sls_service_running }}

            {%- endfor %}
        {%- endif %}
    {%- endfor %}
