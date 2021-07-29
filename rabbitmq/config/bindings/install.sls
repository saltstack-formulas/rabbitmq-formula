# -*- coding: utf-8 -*-
# vim: ft=sls
---
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}
{%- set sls_config_plugins = tplroot ~ '.config.plugins.install' %}
{%- set sls_config_users = tplroot ~ '.config.users.install' %}
{%- set sls_config_vhosts = tplroot ~ '.config.vhosts.install' %}

include:
  - {{ sls_config_plugins }}
  - {{ sls_config_users }}
  - {{ sls_config_vhosts }}

    {%- for name, node in rabbitmq.nodes.items() %}
        {%- if 'bindings' in node and node.bindings is mapping %}
            {%- for binding, b in node.bindings.items() %}

rabbitmq-config-bindings-enabled-{{ name }}-{{ binding }}:
  cmd.run:
    - name: /usr/local/sbin/rabbitmqadmin --node {{ name }} --port={{ node.nodeport + 10000 }} declare binding --vhost={{ b.vhost }} --username={{ b.user }} --password={{ b.passwd }} source={{ b.source }} destination={{ b.destination }} destination_type={{ b.destination_type }} routing_key={{ b.routing_key }} # noqa 204
    - onlyif:
        - test -x /usr/local/sbin/rabbitmqadmin
        - /usr/sbin/rabbitmq-plugins --node {{ name }} is_enabled rabbitmq_management
    - runas: rabbitmq
    - require:
      - sls: {{ sls_config_plugins }}
      - sls: {{ sls_config_users }}
      - sls: {{ sls_config_vhosts }}

            {%- endfor %}
        {%- endif %}
    {%- endfor %}
