# -*- coding: utf-8 -*-
# vim: ft=sls
---
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_file = tplroot ~ '.config.file.install' %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}

include:
  - {{ sls_config_file }}

rabbitmq-service-running-service-running:
  file.directory:
    - name: {{ rabbitmq.dir.data }}
    - user: rabbitmq
    - group: rabbitmq
    - dir_mode: '0755'
  service.running:
    - name: {{ rabbitmq.service.name }}
    - enable: True
    - watch:
      - sls: {{ sls_config_file }}
  cmd.run:
    - names:
      - journalctl -xe -u {{ rabbitmq.service.name }}
      - systemctl status {{ rabbitmq.service.name }}
    - onfail:
      - service: rabbitmq-service-running-service-running
