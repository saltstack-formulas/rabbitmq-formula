# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}
{%- set sls_package_clean = tplroot ~ '.package.clean' %}

include:
  - {{ sls_package_clean }}

    {%- for name, node in rabbitmq.nodes.items() %}

rabbitmq-config-files-absent-{{ name }}:
  file.absent:
    - names:
      - {{ rabbitmq.dir.config }}
    - require_in:
      - sls: {{ sls_package_clean }}

    {%- endfor %}
