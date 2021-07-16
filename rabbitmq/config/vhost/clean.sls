# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}

    {% for name in rabbitmq.vhost %}

rabbitmq-config-vhost-absent-{{ name }}:
  rabbitmq_vhost.absent:
    - name: {{ name }}
    - onlyif: test -x {{ rabbitmq.dir.base }}/bin/rabbitmq-env

    {% endfor %}
