# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}
{%- set sls_rabbitmqadmin_install = tplroot ~ '.rabbitmqadmin.install' %}
{%- set sls_config_vhost = tplroot ~ '.config.vhost.install' %}
{%- set sls_service_running = tplroot ~ '.service.running' %}
{%- set sls_config_user = tplroot ~ '.config.user.install' %}

include:
  - {{ sls_service_running }}
  - {{ sls_rabbitmqadmin_install }}
  - {{ sls_config_vhost }}
  - {{ sls_config_user }}

    {% for name, binding in salt["pillar.get"]("rabbitmq:binding", {}).items() %}

rabbitmq-rabbitmqadmin-binding-present-{{ name }}:
  rabbitmq_binding.present:
    {% for value in binding %}
    - {{ value | json }}
    {% endfor %}
    - require:
      - sls: {{ sls_service_running }}
      - sls: {{ sls_rabbitmqadmin_install }}
      - sls: {{ sls_config_vhost }}
      - sls: {{ sls_config_user }}

    {% endfor %}
