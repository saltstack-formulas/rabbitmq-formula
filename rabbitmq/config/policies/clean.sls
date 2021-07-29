# -*- coding: utf-8 -*-
# vim: ft=sls
---
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}

    {%- for name, node in rabbitmq.nodes.items() %}
        {%- if 'policies' in node and node.policies is mapping %}
            {%- for policy, p in node.policies.items() %}

rabbitmq-config-policies-absent-{{ name }}-{{ policy }}:
  cmd.run:
    - name: /usr/sbin/rabbitmqctl --node {{ name }} clear_policy {{ policy }} {{ '' if 'args' not in p else p.args }}   # noqa 204
    - runas: rabbitmq
    - onlyif:
      - test -x /usr/sbin/rabbitmqctl
      - test -d {{ rabbitmq.dir.data }}

            {%- endfor %}
        {%- endif %}
    {%- endfor %}
