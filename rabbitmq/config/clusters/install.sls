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

rabbitmq-config-clusters-{{ name }}-join-{{ node.join_node }}:
  cmd.run:
    - names:
      - /usr/sbin/rabbitmqctl --node {{ name }} stop_app
      - /usr/sbin/rabbitmqctl --node {{ name }} join_cluster {{ node.join_node }}
      - /usr/sbin/rabbitmqctl --node {{ name }} start_app
      - /usr/sbin/rabbitmqctl --node {{ name }} cluster_status
    - runas: rabbitmq
    - onlyif: test -x /usr/sbin/rabbitmqctl
    - require:
      - file: rabbitmq-config-files-managed-erlang-cookie
      - sls: {{ sls_config_users }}
      - service: rabbitmq-service-running-service-running-{{ name }}

        {%- endif %}
    {%- endfor %}
