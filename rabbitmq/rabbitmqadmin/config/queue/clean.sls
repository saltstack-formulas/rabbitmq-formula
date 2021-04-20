# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}

    {% for name, queue in salt["pillar.get"]("rabbitmq:queue", {}).items() %}

rabbitmq-rabbitmqadmin-queue-absent-{{ name }}:
  rabbitmq_queue.absent:
    - name: {{ queue.name }}

    {% endfor %}
