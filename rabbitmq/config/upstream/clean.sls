# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}
{%- set sls_package_clean = tplroot ~ '.package.clean' %}

include:
  - {{ sls_package_clean }}

    {% for name in rabbitmq.upstream %}

rabbitmq-config-upstream-absent-{{ name }}:
  rabbitmq_upstream.absent:
    - name: {{ name }}
    - require_in:
      - sls: {{ sls_package_clean }}

    {% endfor %}
