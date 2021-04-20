# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}
{%- set sls_package_clean = tplroot ~ '.package.clean' %}

include:
  - {{ sls_package_clean }}

rabbitmq-config-files-file-absent:
  file.absent:
    - names:
      - {{ rabbitmq.config.name }}
      - {{ rabbitmq.env.name }}
      - /etc/rabbitmq
    - require_in:
      - sls: {{ sls_package_clean }}
