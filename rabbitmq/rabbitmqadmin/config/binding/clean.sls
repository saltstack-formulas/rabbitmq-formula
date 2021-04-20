# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}

    {% for name, binding in salt["pillar.get"]("rabbitmq:binding", {}).items() %}

rabbitmq-rabbitmqadmin-binding-absent-{{ name }}:
  rabbitmq_binding.absent:
    - name: {{ binding.name }}

    {% endfor %}
