# -*- coding: utf-8 -*-
# vim: ft=sls
---
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}

    {%- for name, node in rabbitmq.nodes.items() %}
        {%- if 'bindings' in node and node.bindings is mapping %}
            {%- for binding, q in node.bindings.items() %}

rabbitmq-config-bindings-delete-{{ name }}-{{ binding }}:
  cmd.run:
    - name: /usr/local/sbin/rabbitmqadmin --node {{ name }} delete binding --vhost={{ q.vhost }} --username={{ q.user }} --password={{ q.passwd }} name={{ binding }}  # noqa 204
    - onlyif: test -x /usr/local/sbin/rabbitmqadmin
    - runas: rabbitmq

            {%- endfor %}
        {%- endif %}
    {%- endfor %}
