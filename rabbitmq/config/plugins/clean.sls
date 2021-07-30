# -*- coding: utf-8 -*-
# vim: ft=sls
---
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}
{%- set sls_service_clean = tplroot ~ '.service.clean' %}

include:
  - {{ sls_service_clean }}

    {%- for name, node in rabbitmq.nodes.items() %}
        {%- if 'plugins' in node and node.plugins is iterable and node.plugins is not string %}
            {%- for plugin in node.plugins %}

rabbitmq-config-plugins-disabled-{{ name }}-{{ plugin }}:
  cmd.run:
    - name: /usr/sbin/rabbitmq-plugins --node {{ name }} disable {{ plugin }}
    - onlyif:
      - test -d {{ rabbitmq.dir.data }}
      - test -f {{ rabbitmq.dir.config }}/enabled_plugins
      - /usr/sbin/rabbitmq-plugins --node {{ name }} is_enabled {{ plugin }}
    - runas: root
    - require_in:
      - file: rabbitmq-config-plugins-disabled-{{ name }}-{{ plugin }}
      - file: rabbitmq-config-plugins-clean-rabbitmqadmin

            {%- endfor %}
        {%- endif %}
    {%- endfor %}

rabbitmq-config-plugins-clean-rabbitmqadmin:
  file.absent:
    - name: /usr/local/sbin/rabbitmqadmin
    - require_in:
      - sls: {{ sls_service_clean }}
