# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}

    {% for name in rabbitmq.policy %}

rabbitmq-config-policy-absent-{{ name }}:
  rabbitmq_policy.absent:
    - name: {{ name }}
    - onlyif: test -x {{ rabbitmq.dir.base }}/bin/rabbitmq-env

    {% endfor %}
