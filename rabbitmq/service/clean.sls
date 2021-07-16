# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}
{%- set sls_package_clean = tplroot ~ '.package.clean' %}

include:
  - {{ sls_package_clean }}

rabbitmq-service-clean-service-dead:
  service.dead:
    - name: {{ rabbitmq.service.name }}
    - enable: False
    - sig: 'rabbit boot'
    - require_in:
      - sls: {{ sls_package_clean }}
