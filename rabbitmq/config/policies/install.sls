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
            {%- for policy, items in node.policies.items() %}

rabbitmq-config-policies-present-{{ name }}-{{ policy }}:
  cmd.run:
    - name: /usr/sbin/rabbitmqctl --node {{ name }} set_policy {{ policy }} "{{ items.pattern }}" '{{ items.definition }}' {{ '' if 'args' not in items else items.args }}  # noqa 204
    - onlyif: test -x /usr/sbin/rabbitmqctl
    - require:
      - sls: {{ sls_service_running }}

            {%- endfor %}
        {%- endif %}
    {%- endfor %}
