# -*- coding: utf-8 -*-
# vim: ft=sls
---
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}
{%- set sls_service_clean = tplroot ~ '.service.clean' %}
{%- set sls_config_users_clean = tplroot ~ '.config.users.clean' %}
{%- set sls_config_plugins_clean = tplroot ~ '.config.plugins.clean' %}

include:
  - {{ sls_service_clean }}
  - {{ sls_config_plugins_clean }}
  - {{ sls_config_users_clean }}

    {%- for name, node in rabbitmq.nodes.items() %}
        {%- if 'vhosts' in node and node.vhosts is iterable and node.vhosts is not string %}
            {%- for vhost in node.vhosts %}

rabbitmq-config-vhosts-delete-{{ name }}-{{ vhost }}:
  cmd.run:
    - name: /usr/sbin/rabbitmqctl --node {{ name }} delete_vhost {{ vhost }} || true
    - onlyif:
      - test -x /usr/sbin/rabbitmqctl
      - test -d {{ rabbitmq.dir.data }}
    - runas: rabbitmq
    - require_in:
      - sls: {{ sls_service_clean }}
      - sls: {{ sls_config_plugins_clean }}
      - sls: {{ sls_config_users_clean }}

            {%- endfor %}
        {%- endif %}
    {%- endfor %}
