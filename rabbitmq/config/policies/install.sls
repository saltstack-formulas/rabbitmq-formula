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
  cmd.run:
    - name: /usr/sbin/rabbitmqctl --node {{ name }} set_policy {{ policy }} --vhost={{ '/' if 'vhost' not in p else p.vhost }} '{{ p.pattern }}' '{{ p.definition }}' --priority {{ 0 if 'priority' not in p else p.priority }} --apply-to {{ 'all' if 'apply_to' not in p else p.apply_to }}  # noqa 204
    - runas: rabbitmq
    - onlyif: test -x /usr/sbin/rabbitmqctl
    - require:
      - service: rabbitmq-service-running-service-running-{{ name }}

            {%- endfor %}
        {%- endif %}
    {%- endfor %}
