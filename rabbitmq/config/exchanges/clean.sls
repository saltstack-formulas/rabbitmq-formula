# -*- coding: utf-8 -*-
# vim: ft=sls
---
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}
{%- set sls_config_users_clean = tplroot ~ '.config.users.clean' %}
{%- set sls_config_vhosts_clean = tplroot ~ '.config.vhosts.clean' %}
{%- set sls_config_plugins_clean = tplroot ~ '.config.plugins.clean' %}

include:
  - {{ sls_config_plugins_clean }}
  - {{ sls_config_users_clean }}
  - {{ sls_config_vhosts_clean }}

    {%- for name, node in rabbitmq.nodes.items() %}
        {%- if 'exchanges' in node and node.exchanges is mapping %}
            {%- for exchange, q in node.exchanges.items() %}

rabbitmq-config-exchanges-delete-{{ name }}-{{ exchange }}:
  cmd.run:
    - name: /usr/local/sbin/rabbitmqadmin --node {{ name }} --port={{ node.nodeport + 10000 }} delete exchange --vhost={{ q.vhost }} --username={{ q.user }} --password={{ q.passwd }} name={{ exchange }} || true  # noqa 204
    - onlyif:
      - test -x /usr/local/sbin/rabbitmqadmin
      - test -d {{ rabbitmq.dir.data }}
    - runas: rabbitmq
    - require_in:
      - {{ sls_config_users_clean }}
      - {{ sls_config_vhosts_clean }}
      - {{ sls_config_plugins_clean }}

            {%- endfor %}
        {%- endif %}
    {%- endfor %}
