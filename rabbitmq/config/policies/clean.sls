# -*- coding: utf-8 -*-
# vim: ft=sls
---
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}
{%- set sls_config_users_clean = tplroot ~ '.config.users.clean' %}
{%- set sls_config_vhosts_clean = tplroot ~ '.config.vhosts.clean' %}

include:
  - {{ sls_config_users_clean }}
  - {{ sls_config_vhosts_clean }}

    {%- for name, node in rabbitmq.nodes.items() %}
        {%- if 'policies' in node and node.policies is mapping %}
            {%- for policy, p in node.policies.items() %}

rabbitmq-config-policies-clear-{{ name }}-{{ policy }}:
  cmd.run:
    - name: /usr/sbin/rabbitmqctl --node {{ name }} clear_policy {{ policy }} --vhost={{ '/' if 'vhost' not in p else p.vhost }} || true # noqa 204
    - onlyif:
      - test -x /usr/sbin/rabbitmqctl
      - test -d {{ rabbitmq.dir.data }}
    - runas: rabbitmq
    - require_in:
      - sls: {{ sls_config_vhosts_clean }}
      - sls: {{ sls_config_users_clean }}


            {%- endfor %}
        {%- endif %}
    {%- endfor %}
