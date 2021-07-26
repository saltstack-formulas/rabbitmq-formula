# -*- coding: utf-8 -*-
# vim: ft=sls
---
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}

    {%- for name, node in rabbitmq.nodes.items() %}
        {%- if 'exchanges' in node and node.exchanges is mapping %}
            {%- for exchange, q in node.exchanges.items() %}

rabbitmq-config-exchanges-delete-{{ name }}-{{ exchange }}:
  cmd.run:
    - name: /usr/local/sbin/rabbitmqadmin --node {{ name }} delete exchange --vhost={{ q.vhost }} --username={{ q.user }} --password={{ q.passwd }} name={{ exchange }}  # noqa 204
    - onlyif: test -x /usr/local/sbin/rabbitmqadmin
    - runas: rabbitmq

            {%- endfor %}
        {%- endif %}
    {%- endfor %}
