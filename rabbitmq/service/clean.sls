# -*- coding: utf-8 -*-
# vim: ft=sls
---
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}

    {%- for name, node in rabbitmq.nodes.items() %}
        {%- if 'service' in node and node.service %}
            {%- set svcname = 'rabbitmq-server' %}
            {%- if name != 'rabbit' %}
                {%- set svcname = svcname ~ '-' ~ name %}
            {%- endif %}

rabbitmq-service-dead-service-{{ name }}:
  service.dead:
    - name: {{ svcname }}
    - enable: False
    - onlyif: systemctl status svcname
  file.absent:
    - names:
      - '{{ rabbitmq.dir.service }}/{{ svcname }}.service'
      - '/etc/systemd/system/{{ svcname }}.service.d/limits.conf'
    - watch_in:
      - cmd: rabbitmq-service-dead-daemon-reload

        {%- endif %}
    {%- endfor %}

rabbitmq-service-dead-daemon-reload:
  cmd.run:
    - name: systemctl daemon-reload
