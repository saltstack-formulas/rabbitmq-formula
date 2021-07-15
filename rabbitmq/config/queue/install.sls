# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}
{%- set sls_service_running = tplroot ~ '.service.running' %}

include:
  - {{ sls_service_running }}

    {% for name, q in salt["pillar.get"]("rabbitmq:queue", {}).items() %}

rabbitmq-config-queue-present-{{ name }}:
  cmd.run:
    - name: /usr/local/sbin/rabbitmqadmin declare queue --vhost={{ q.vhost }} --username={{ q.user }} --password={{ q.passwd }} name={{ name }} durable={{ q.durable|to_bool|lower }} auto_delete={{ q.auto_delete|to_bool|lower }}  # noqa 204
    - require:
      - sls: {{ sls_service_running }}

    {% endfor %}
