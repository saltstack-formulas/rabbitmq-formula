# -*- coding: utf-8 -*-
# vim: ft=sls
---
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}
{%- set sls_config_plugins = tplroot ~ '.config.plugins.install' %}
{%- set sls_config_users = tplroot ~ '.config.users.install' %}
{%- set sls_config_vhosts = tplroot ~ '.config.vhosts.install' %}

include:
  - {{ sls_config_plugins }}
  - {{ sls_config_users }}
  - {{ sls_config_vhosts }}

    {%- for name, node in rabbitmq.nodes.items() %}
        {%- if 'exchanges' in node and node.exchanges is mapping %}
            {%- for exchange, ex in node.exchanges.items() %}

rabbitmq-config-exchanges-enabled-{{ name }}-{{ exchange }}:
  cmd.run:
    - name: >-
            /usr/local/sbin/rabbitmqadmin --node {{ name }} --port={{ node.nodeport + 10000 }} declare exchange --vhost={{ ex.vhost }} --username={{ ex.user }} --password={{ ex.passwd }} name={{ exchange }} type={{ ex.type }} durable={{ ex.durable }} internal={{ ex.internal }} auto_delete={{ ex.auto_delete }} arguments='{{ "{}" if "arguments" not in ex else ex.arguments|json }}'  # noqa 204
    - onlyif:
        - test -x /usr/local/sbin/rabbitmqadmin
        - /usr/sbin/rabbitmq-plugins --node {{ name }} is_enabled rabbitmq_management
    - runas: rabbitmq
    - require:
      - sls: {{ sls_config_plugins }}
      - sls: {{ sls_config_users }}
      - sls: {{ sls_config_vhosts }}

            {%- endfor %}
        {%- endif %}
    {%- endfor %}
