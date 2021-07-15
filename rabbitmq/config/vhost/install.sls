# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}
{%- set sls_service_running = tplroot ~ '.service.running' %}

include:
  - {{ sls_service_running }}

    {% for name in rabbitmq.vhost %}

rabbitmq-config-vhost-present-{{ name }}:
  rabbitmq_vhost.present:
    - name: {{ name }}
    - require:
      - sls: {{ sls_service_running }}

    {% endfor %}
