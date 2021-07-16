# -*- coding: utf-8 -*-
# vim: ft=sls
---
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}

    {%- for name, node in salt["pillar.get"]("rabbitmq:nodes", {}).items() %}
        {%- if 'upstreams' in node and node.upstreams is mapping %}
            {%- for upstream, items in node.upstreams.items() %}

rabbitmq-config-upstreams-absent-{{ upstream }}:
  rabbitmq_upstream.absent:
                {% for v in items %}
    - {{ v | json }}
                {% endfor %}

            {%- endfor %}
        {%- endif %}
    {%- endfor %}
