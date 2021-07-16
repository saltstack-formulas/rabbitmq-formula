# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}
{%- set sls_service_running = tplroot ~ '.service.running' %}
{%- set sls_config_user = tplroot ~ '.config.user.install' %}

include:
  - {{ sls_service_running }}
  - {{ sls_config_user }}

    {%- for name, node in salt["pillar.get"]("rabbitmq:nodes", {}).items() %}
        {%- if node and 'clustered' in node and node.clustered %}

rabbitmq-config-clusters-{{ name }}-join-{{ node.join_node }}:
  file.managed:
    - name: {{ rabbitmq.dir.data }}/{{ name }}/.erlang.cookie
    - contents: {{ node.erlang_cookie }}
    - mode: 400
    - user: rabbitmq
    - group: {{ rabbitmq.rootgroup }}
    - makedirs: True
    - require:
      - sls: {{ sls_service_running }}
  cmd.run:
    - name: /usr/sbin/rabbitmqctl --node {{ name }} join_cluster {{ items.join_node }}
    - runas: rabbitmq
    - onlyif: test -x /usr/sbin/rabbitmqctl
    - require:
      - file: rabbitmq-config-clusters-{{ name }}-join-{{ node.host }}
      - sls: {{ sls_config_user }}
      - sls: {{ sls_service_running }}

        {%- endif %}
    {%- endfor %}
