# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}
{%- set sls_package_clean = tplroot ~ '.package.clean' %}

include:
  - {{ sls_package_clean }}

    {%- if rabbitmq.cluster %}
        {%- for name, cluster in salt["pillar.get"]("rabbitmq:cluster", {}).items() %}

rabbitmq-service-running-Clean-{{ name }}:
  service.dead:
    - name: {{ rabbitmq.service.name }}-{{ name }}
  file.absent:
    - names:
      - {{ rabbitmq.dir.service }}/{{ rabbitmq.service.name }}-{{ name }}.service
      - {{ rabbitmq.dir.data }}/{{ name }}/.erlang.cookie
    - watch_in:
      - cmd: rabbitmq-service-clean-daemon-reload

rabbitmq-service-running-clean-service-dead-{{ name }}:
  service.dead:
    - name: {{ rabbitmq.service.name }}-{{ name }}
    - enable: False

        {%- endfor %}
    {%- else %}

rabbitmq-service-clean-service-dead:
  service.dead:
    - name: {{ rabbitmq.service.name }}
    - enable: False
    - sig: 'rabbit boot'
    - require_in:
      - sls: {{ sls_package_clean }}

    {%- endif %}

rabbitmq-service-clean-daemon-reload:
  cmd.run:
    - name: systemctl daemon-reload
