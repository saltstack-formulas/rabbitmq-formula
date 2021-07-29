# -*- coding: utf-8 -*-
# vim: ft=sls
---
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}
{%- set sls_service_running = tplroot ~ '.service.running' %}

include:
  - {{ sls_service_running }}

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

            {%- endfor %}
        {%- endif %}
    {%- endfor %}
