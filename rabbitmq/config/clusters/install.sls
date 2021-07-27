# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}
{%- set sls_service_running = tplroot ~ '.service.running' %}
{%- set sls_config_users = tplroot ~ '.config.users.install' %}
{%- set sls_config_files = tplroot ~ '.config.files.install' %}

include:
  - {{ sls_service_running }}
  - {{ sls_config_users }}
  - {{ sls_config_files }}

    {%- for name, node in rabbitmq.nodes.items() %}
        {%- if 'clustered' in node and node.clustered and 'join_node' in node %}
            {%- if 'erlang_cookie' in node and node.erlang_cookie %}

rabbitmq-config-clusters-{{ name }}-join-{{ node.join_node }}:
  cmd.run:
    - names:
      - /usr/sbin/rabbitmqctl --node {{ name }}@localhost stop_app
      - /usr/sbin/rabbitmqctl --node {{ name }}@localhost join_cluster {{ node.join_node }}
      - /usr/sbin/rabbitmqctl --node {{ name }}@localhost start_app
      - /usr/sbin/rabbitmqctl --node {{ name }}@localhost cluster_status
    - runas: rabbitmq
    - onlyif: test -x /usr/sbin/rabbitmqctl
    - require:
      - file: rabbitmq-config-files-managed-{{ name }}-erlang-cookie
      - sls: {{ sls_config_users }}
      - service: rabbitmq-service-running-service-running-{{ name }}

            {%- endif %}
        {%- endif %}
    {%- endfor %}
