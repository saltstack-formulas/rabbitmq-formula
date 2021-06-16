# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}
{%- set sls_service_running = tplroot ~ '.service.running' %}

include:
  - {{ sls_service_running }}

    {% for name, q in salt["pillar.get"]("rabbitmq:queue", {}).items() %}

rabbitmq-config-queue-absent-{{ name }}:
  cmd.run:
    - name: /usr/local/sbin/rabbitmqadmin delete queue --vhost={{ q.vhost }} --username={{ q.user }} --password={{ q.passwd }} name={{ name }}  # noqa 204
    - require:
      - service: rabbitmq-service-running-service-running

    {% endfor %}
