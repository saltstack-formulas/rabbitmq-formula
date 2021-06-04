# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}
{%- set sls_service_running = tplroot ~ '.service.running' %}
{%- set sls_config_user = tplroot ~ '.config.user.install' %}

include:
  - {{ sls_service_running }}
  - {{ sls_config_user }}

    {%- for name, cluster in salt["pillar.get"]("rabbitmq:cluster", {}).items() %}
        {%- if 'erlang_cookie' in cluster and cluster.erlang_cookie is mapping %}

rabbitmq-config-cluster-join-{{ name }}:
  file.managed:
    - name: {{ cluster.erlang_cookie.name }}
    - contents: {{ cluster.erlang_cookie.value }}
    - mode: 400
    - user: {{ cluster.user }}
    - group: root
    - makedirs: True
    - watch_in:
      - service: rabbitmq-service-running-service-running

            {%- if 'host' in grains and grains.host not in cluster.host %}

  rabbitmq_cluster.joined:
    - user: {{ cluster.user }}
    - host: {{ cluster.host }}
    - ram_node: {{ cluster.ram_node }}
    - runas: {{ cluster.runas }}
    - require:
      - file: rabbitmq-config-cluster-join-{{ name }}
      - sls: {{ sls_config_user }}
      - service: rabbitmq-service-running-service-running

            {%- endif %}
        {%- endif %}
    {%- endfor %}
