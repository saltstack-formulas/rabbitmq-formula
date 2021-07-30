# -*- coding: utf-8 -*-
# vim: ft=sls
---
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}
{%- set sls_service_running = tplroot ~ '.service.running' %}

include:
  - {{ sls_service_running }}

    {%- for name, node in rabbitmq.nodes.items() %}
        {%- if 'upstreams' in node and node.upstreams is mapping %}
            {%- for upstream, p in node.upstreams.items() %}

rabbitmq-config-upstreams-enabled-{{ name }}-{{ upstream }}:
  rabbitmq_upstream.present:
    - name: {{ upstream }}
                {%- for v in p %}
    - {{ v|yaml }}
                {%- endfor %}
    - onlyif: test -x /usr/sbin/rabbitmqctl
    - runas: rabbitmq
    - require:
      - service: rabbitmq-service-running-service-running-{{ name }}

            {%- endfor %}
        {%- endif %}
    {%- endfor %}
