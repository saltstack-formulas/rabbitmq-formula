# -*- coding: utf-8 -*-
# vim: ft=sls
---
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}
{%- set sls_service_running = tplroot ~ '.service.running' %}

include:
  - {{ sls_service_running }}

    {%- for name, node in salt["pillar.get"]("rabbitmq:nodes", {}).items() %}
        {%- if 'upstreams' in node and node.upstreams is mapping %}
            {%- for upstream, items in node.upstreams.items() %}

rabbitmq-config-upstreams-present-{{ upstream }}:
  rabbitmq_upstream.present:
                {% for v in items %}
    - {{ v | json }}
                {% endfor %}
    - require:
      - sls: {{ sls_service_running }}

            {%- endfor %}
        {%- endif %}
    {%- endfor %}
