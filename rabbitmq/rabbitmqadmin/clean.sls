# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}

rabbitmq-rabbitmqadmin-clean:
  file.absent:
    - name: /usr/local/sbin/rabbitmqadmin
