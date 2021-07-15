# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}
{%- set sls_service_running = tplroot ~ '.service.running' %}

include:
  - {{ sls_service_running }}

    {% for name, policy in salt["pillar.get"]("rabbitmq:policy", {}).items() %}

rabbitmq-config-policy-present-{{ name }}:
  rabbitmq_policy.present:
        {% for value in policy %}
    - {{ value | json }}
        {% endfor %}
    - require:
      - sls: {{ sls_service_running }}

    {% endfor %}
