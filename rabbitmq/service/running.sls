# -*- coding: utf-8 -*-
# vim: ft=sls
---
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_file = tplroot ~ '.config.file.install' %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}

include:
  - {{ sls_config_file }}

    {%- if grains.os_family == 'RedHat' %}   # fix timeout
rabbitmq-service-running-service-running-limits:
  file.managed:
    - onlyif: {{ grains.os_family == 'RedHat' }}   # fix timeout
    - name: /etc/systemd/system/{{ rabbitmq.service.name }}.service.d/limits.conf
    - user: root
    - group: root
    - makedirs: true
    - contents:
      - [Service]
      - LimitNOFILE=65536
      - TimeoutSec=300
    - require_in:
      - service: rabbitmq-service-running-service-running

        {%- if rabbitmq.env.locale_all %}
  environ.setenv:
    - name: LC_ALL
    - value: {{ rabbitmq.env.locale_all }}
    - update_minion: True
        {%- endif %}
    {%- endif %}

rabbitmq-service-running-service-running:
  file.directory:
    - name: {{ rabbitmq.dir.data }}
    - user: rabbitmq
    - group: rabbitmq
    - dir_mode: '0755'
  service.running:
    - name: {{ rabbitmq.service.name }}
    - retry: {{ rabbitmq.retry_option|json }}
    - enable: True
    - watch:
      - sls: {{ sls_config_file }}
  cmd.run:
    - names:
      - cat /etc/locale.conf
      - localectl || true
      - locale || true
      - journalctl -xe -u {{ rabbitmq.service.name }} || true
      - systemctl status {{ rabbitmq.service.name }} || true
      - systemd-analyze blame || true
      - hostname
      - hostname -s
      - hostname -A
      - ip addr
    - onfail:
      - service: rabbitmq-service-running-service-running
