# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}
{%- set sls_service_running = tplroot ~ '.service.running' %}

include:
  - {{ sls_service_running }}

    {% for name, upstream in salt["pillar.get"]("rabbitmq:upstream", {}).items() %}

rabbitmq-config-upstream-present-{{ name }}:
  rabbitmq_upstream.present:
    {% for value in upstream %}
    - {{ value | json }}
    {% endfor %}
    - require:
      - sls: {{ sls_service_running }}

    {% endfor %}
