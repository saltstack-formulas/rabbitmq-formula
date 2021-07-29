# -*- coding: utf-8 -*-
# vim: ft=sls
---
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}
{%- set sls_service_running = tplroot ~ '.service.running' %}
{%- set sls_config_plugins = tplroot ~ '.config.plugins.install' %}

include:
  - {{ sls_service_running }}
  - {{ sls_config_plugins }}

    {%- for name, node in rabbitmq.nodes.items() %}
        {%- if 'exchanges' in node and node.exchanges is mapping %}
            {%- for exchange, ex in node.exchanges.items() %}

rabbitmq-config-exchanges-enabled-{{ name }}-{{ exchange }}:
  cmd.run:
    - name: /usr/local/sbin/rabbitmqadmin --node {{ name }} declare exchange --vhost={{ ex.vhost }} --username={{ ex.user }} --password={{ ex.passwd }} name={{ exchange }} type={{ ex.type }} durable={{ ex.durable }} internal={{ ex.internal }} auto_delete={{ ex.auto_delete }}  # noqa 204
    - onlyif: test -x /usr/sbin/rabbitmqctl
    - runas: rabbitmq
    - require:
      - service: rabbitmq-service-running-service-running-{{ name }}
      - sls: {{ sls_config_plugins }}

            {%- endfor %}
        {%- endif %}
    {%- endfor %}
