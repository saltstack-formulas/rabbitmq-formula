# -*- coding: utf-8 -*-
# vim: ft=sls
---
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}
{%- set sls_service_running = tplroot ~ '.service.running' %}

include:
  - {{ sls_service_running }}

    {%- for name, node in rabbitmq.nodes.items() %}
        {%- if 'policies' in node and node.policies is mapping %}
            {%- for policy, p in node.policies.items() %}

rabbitmq-config-policies-enabled-{{ name }}-{{ policy }}:
  rabbitmq_policy.present:
    - name: {{ policy }}
    - pattern: {{ p.pattern }}
    - definition: '{{ p.definition }}'
    - priority: {{ 0 if 'priority' not in p else p.priority }}
    - vhost: {{ '/' if 'vhost' not in p else p.vhost }}
    - apply_to: {{ 'all' if 'apply_to' not in p else p.apply_to }}
    - onlyif: test -x /usr/sbin/rabbitmqctl
    - runas: rabbitmq
    - require:
      - service: rabbitmq-service-running-service-running-{{ name }}

            {%- endfor %}
        {%- endif %}
    {%- endfor %}
