# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}

    {% for name, user in salt["pillar.get"]("rabbitmq:user", {}).items() %}

rabbitmq-config-user-absent-{{ name }}:
  rabbitmq_user.absent:
    - name: {{ name }}
    - onlyif: test -x {{ rabbitmq.dir.base }}/bin/rabbitmq-env

    {% endfor %}
