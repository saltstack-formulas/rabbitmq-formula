# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}
{%- set sls_package_clean = tplroot ~ '.package.clean' %}

include:
  - {{ sls_package_clean }}

    {% for name in rabbitmq.policy %}

rabbitmq-config-policy-absent-{{ name }}:
  rabbitmq_policy.absent:
    - name: {{ name }}
    - onlyif: test -x {{ rabbitmq.dir.base }}/bin/rabbitmq-env
    - require_in:
      - sls: {{ sls_package_clean }}

    {% endfor %}
