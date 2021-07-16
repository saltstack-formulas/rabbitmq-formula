# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}
{%- set sls_service_running = tplroot ~ '.service.running' %}
{%- set sls_config_vhost = tplroot ~ '.config.vhost.install' %}

include:
  - {{ sls_service_running }}
  - {{ sls_config_vhost }}

    {% for name, user in salt["pillar.get"]("rabbitmq:user", {}).items() %}

rabbitmq-config-user-present-{{ name }}:
  rabbitmq_user.present:
    - name: {{ name }}
      {%- for item in user %}
    - {{ item|json }}
      {%- endfor %}
    - require:
      - sls: {{ sls_service_running }}
      - sls: {{ sls_config_vhost }}

    {% endfor %}
    {% if salt['pillar.get']('rabbitmq:remove_guest_user', True) %}

rabbitmq-config-user-guest-absent:
  rabbitmq_user.absent:
    - name: guest

    {% endif %}
