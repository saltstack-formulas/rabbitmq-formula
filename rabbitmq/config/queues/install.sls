# -*- coding: utf-8 -*-
# vim: ft=sls
---
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}
{%- set sls_service_running = tplroot ~ '.service.running' %}
{%- set sls_config_plugins = tplroot ~ '.config.plugins.install' %}
{%- set sls_config_users = tplroot ~ '.config.users.install' %}
{%- set sls_config_vhosts = tplroot ~ '.config.vhosts.install' %}

include:
  - {{ sls_service_running }}
  - {{ sls_config_plugins }}
  - {{ sls_config_users }}
  - {{ sls_config_vhosts }}

    {%- for name, node in rabbitmq.nodes.items() %}
        {%- if 'queues' in node and node.queues is mapping %}
            {%- for queue, q in node.queues.items() %}

rabbitmq-config-queues-enabled-{{ name }}-{{ queue }}:
  cmd.run:
    - name: /usr/local/sbin/rabbitmqadmin --node {{ name }} declare queue --vhost={{ q.vhost }} --username={{ q.user }} --password={{ q.passwd }} name={{ queue }} durable={{ q.durable|to_bool|lower }} auto_delete={{ q.auto_delete|to_bool|lower }}  # noqa 204
    - onlyif: test -x /usr/sbin/rabbitmqctl
    - runas: rabbitmq
    - require:
      - service: rabbitmq-service-running-service-running-{{ name }}
      - sls: {{ sls_config_plugins }}
      - sls: {{ sls_config_users }}
      - sls: {{ sls_config_vhosts }}

            {%- endfor %}
        {%- endif %}
    {%- endfor %}
