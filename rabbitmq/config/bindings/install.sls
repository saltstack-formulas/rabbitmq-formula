# -*- coding: utf-8 -*-
# vim: ft=sls
---
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}
{%- set sls_service_running = tplroot ~ '.service.running' %}
{%- set sls_config_plugins = tplroot ~ '.config.plugins.install' %}
{%- set sls_config_users = tplroot ~ '.config.users.install' %}
{%- set sls_config_vhosts = tplroot ~ '.config.vhosts.install' %}

include:
  - {{ sls_service_running }}
  - {{ sls_config_plugins }}
  - {{ sls_config_users }}
  - {{ sls_config_vhosts }}

    {%- for name, node in rabbitmq.nodes.items() %}
        {%- if 'bindings' in node and node.bindings is mapping %}
            {%- for binding, b in node.bindings.items() %}

rabbitmq-config-bindings-enabled-{{ name }}-{{ binding }}:
  cmd.run:
    - name: /usr/local/sbin/rabbitmqadmin --node {{ name }} declare binding --vhost={{ b.vhost }} --username={{ b.user }} --password={{ b.passwd }} source={{ b.source }} destination={{ b.destination }} destination_type={{ b.destination_type }} routing_key={{ b.routing_key }} # noqa 204
    - onlyif: test -x /usr/sbin/rabbitmqctl
    - runas: rabbitmq
    - require:
      - service: rabbitmq-service-running-service-running-{{ name }}
      - sls: {{ sls_config_plugins }}
      - sls: {{ sls_config_users }}
      - sls: {{ sls_config_vhosts }}

            {%- endfor %}
        {%- endif %}
    {%- endfor %}
