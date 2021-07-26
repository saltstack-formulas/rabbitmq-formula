# -*- coding: utf-8 -*-
# vim: ft=sls
---
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}
{%- set sls_service_running = tplroot ~ '.service.running' %}

include:
  - {{ sls_service_running }}

    {%- for name, node in rabbitmq.nodes.items() %}
        {%- if 'queues' in node and node.queues is mapping %}
            {%- for queue, q in node.queues.items() %}

rabbitmq-config-queues-enabled-{{ name }}-{{ queue }}:
  cmd.run:
    - name: /usr/local/sbin/rabbitmqadmin --node {{ name }} declare queue --vhost={{ q.vhost }} --username={{ q.user }} --password={{ q.passwd }} name={{ queue }} durable={{ q.durable|to_bool|lower }} auto_delete={{ q.auto_delete|to_bool|lower }}  # noqa 204
    - onlyif: test -x /usr/sbin/rabbitmqctl
    - runas: rabbitmq
    - require:
      - sls: {{ sls_service_running }}

            {%- endfor %}
        {%- endif %}
    {%- endfor %}
