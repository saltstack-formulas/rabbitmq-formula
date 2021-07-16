# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}

    {% for name in rabbitmq.upstream %}

rabbitmq-config-upstream-absent-{{ name }}:
  rabbitmq_upstream.absent:
    - name: {{ name }}

    {% endfor %}
