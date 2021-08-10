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
        {%- if 'queues' in node and node.queues is mapping %}
            {%- for queue, q in node.queues.items() %}

rabbitmq-config-queues-enabled-{{ name }}-{{ queue }}:
  cmd.run:
    - name: >-
            /usr/local/sbin/rabbitmqadmin --node {{ name }} --port={{ node.nodeport + 10000 }} declare queue --vhost={{ q.vhost }} --username={{ q.user }} --password={{ q.passwd }} name={{ queue }} durable={{ q.durable|to_bool|lower }} auto_delete={{ q.auto_delete|to_bool|lower }} arguments='{{ "{}" if "arguments" not in q else q.arguments|json }}'  # noqa 204
    - onlyif: test -x /usr/local/sbin/rabbitmqadmin
    - runas: rabbitmq
    - require:
      - sls: {{ sls_config_plugins }}
      - sls: {{ sls_config_users }}
      - sls: {{ sls_config_vhosts }}
    - unless: /usr/sbin/rabbitmqctl --node {{ name }} --vhost={{ vhost }} list_queues | grep ^{{ queue }}\s*

            {%- endfor %}
        {%- endif %}
    {%- endfor %}
