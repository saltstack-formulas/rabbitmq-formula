# -*- coding: utf-8 -*-
# vim: ft=sls
---
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}
{%- set sls_service_running = tplroot ~ '.service.running' %}

include:
  - {{ sls_service_running }}

    {%- for name, node in salt["pillar.get"]("rabbitmq:nodes", {}).items() %}
        {%- if 'exchanges' in node and node.exchanges is mapping %}
            {%- for exchange, ex in node.exchanges.items() %}

rabbitmq-config-exchanges-enabled-{{ name }}-{{ exchange }}:
  cmd.run:
    - name: /usr/local/sbin/rabbitmqadmin --node {{ name }} declare exchange --vhost={{ ex.vhost }} --username={{ ex.user }} --password={{ ex.passwd }} name={{ exchange }}  # noqa 204
    - onlyif: test -x /usr/sbin/rabbitmqctl
    - runas: rabbitmq
    - require:
      - sls: {{ sls_service_running }}

            {%- endfor %}
        {%- endif %}
    {%- endfor %}
