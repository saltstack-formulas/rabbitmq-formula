# -*- coding: utf-8 -*-
# vim: ft=sls
---
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}

    {%- for name, node in salt["pillar.get"]("rabbitmq:nodes", {}).items() %}
        {%- if 'service' in node and node.service %}

            {%- set name = '-' ~ name %}
            {%- if name == '-rabbit' %}
                {%- set name='' %}
            {%- endif %}

rabbitmq-service-dead-service{{ name }}:
  service.dead:
    - name: rabbitmq-server{{ name }}
    - enable: False
  file.absent:
    - names:
      - '{{ rabbitmq.dir.service }}/rabbitmq-server{{ name|replace('-', '') }}.service'
      - '/etc/systemd/system/rabbitmq-server{{ name|replace('-', '') }}.service.d/limits.conf'
    - watch_in:
      - cmd: rabbitmq-service-dead-daemon-reload

        {%- endif %}
    {%- endfor %}

rabbitmq-service-dead-daemon-reload:
  cmd.run:
    - name: systemctl daemon-reload
