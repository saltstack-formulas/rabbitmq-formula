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
        {%- if 'bindings' in node and node.bindings is mapping %}
            {%- for binding, b in node.bindings.items() %}

rabbitmq-config-bindings-delete-{{ name }}-{{ binding }}:
  cmd.run:
    - name: /usr/local/sbin/rabbitmqadmin --node {{ name }} --port={{ node.nodeport + 10000 }} delete binding --vhost={{ b.vhost }} --username={{ b.user }} --password={{ b.passwd }} source={{ b.source }} destination={{ b.destination }} destination_type={{ b.destination_type }} || true  # noqa 204
    - onlyif:
      - test -x /usr/local/sbin/rabbitmqadmin
      - test -d {{ rabbitmq.dir.data }}
    - runas: rabbitmq
    - require_in:
      - sls: {{ sls_config_plugins_clean }}
      - sls: {{ sls_config_users_clean }}
      - sls: {{ sls_config_vhosts_clean }}

            {%- endfor %}
        {%- endif %}
    {%- endfor %}
