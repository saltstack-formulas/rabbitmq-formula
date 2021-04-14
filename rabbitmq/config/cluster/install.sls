# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}
{%- set sls_service_running = tplroot ~ '.service.running' %}
{%- set sls_config_user = tplroot ~ '.config.user.install' %}

include:
  - {{ sls_service_running }}
  - {{ sls_config_user }}

    {% for name, cluster in salt["pillar.get"]("rabbitmq:cluster", {}).items() %}

rabbitmq-config-cluster-join-{{ name }}:
  rabbitmq_cluster.join:
    {% for value in cluster %}
    - {{ value | json }}
    {% endfor %}
    - require:
      - service: {{ rabbitmq.service.name }}
      - sls: {{ sls_config_user }}

    {% endfor %}
