# -*- coding: utf-8 -*-
# vim: ft=sls
---
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}

    {%- for name, node in rabbitmq.nodes.items() %}
        {%- if 'bindings' in node and node.bindings is mapping %}
            {%- for binding, b in node.bindings.items() %}

rabbitmq-config-bindings-delete-{{ name }}-{{ binding }}:
  cmd.run:
    - name: /usr/local/sbin/rabbitmqadmin --node {{ name }} delete binding --vhost={{ b.vhost }} --username={{ b.user }} --password={{ b.passwd }} source={{ b.source }} destination={{ b.destination }} destination_type={{ b.destination_type }} routing_key={{ b.routing_key }} # noqa 204
    - onlyif:
      - test -x /usr/local/sbin/rabbitmqadmin
      - test -d {{ rabbitmq.dir.data }}
    - runas: rabbitmq

            {%- endfor %}
        {%- endif %}
    {%- endfor %}
