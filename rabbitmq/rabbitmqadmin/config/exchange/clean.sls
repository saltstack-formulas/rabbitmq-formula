# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}

    {% for name, exchange in salt["pillar.get"]("rabbitmq:exchange", {}).items() %}

rabbitmq-rabbitmqadmin-exchange-absent-{{ name }}:
  rabbitmq_exchange.absent:
    - name: {{ exchange.name }}

    {% endfor %}
