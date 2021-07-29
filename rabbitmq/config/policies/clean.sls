# -*- coding: utf-8 -*-
# vim: ft=sls
---
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}

    {%- for name, node in rabbitmq.nodes.items() %}
        {%- if 'policies' in node and node.policies is mapping %}
            {%- for policy, p in node.policies.items() %}

rabbitmq-config-policies-absent-{{ name }}-{{ policy }}:
  rabbitmq_policy.absent:
                {%- for l in p %}
    - {{ l|yaml }}
                {%- endfor %}
    - runas: rabbitmq
    - onlyif:
      - test -x /usr/sbin/rabbitmqctl
      - test -d {{ rabbitmq.dir.data }}

            {%- endfor %}
        {%- endif %}
    {%- endfor %}
