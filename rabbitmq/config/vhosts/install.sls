# -*- coding: utf-8 -*-
# vim: ft=sls
---
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}
{%- set sls_config_plugins = tplroot ~ '.config.plugins.install' %}
{%- set sls_config_users = tplroot ~ '.config.users.install' %}

include:
  - {{ sls_config_plugins }}
  - {{ sls_config_users }}

    {%- for name, node in rabbitmq.nodes.items() %}
        {%- if 'vhosts' in node and node.vhosts is iterable and node.vhosts is not string %}
            {%- for vhost in node.vhosts %}

rabbitmq-config-vhosts-add-{{ name }}-{{ vhost }}:
  cmd.run:
    - name: /usr/sbin/rabbitmqctl --node {{ name }} add_vhost {{ vhost }}
    - onlyif: test -x /usr/sbin/rabbitmqctl
    - runas: rabbitmq
    - require:
      - sls: {{ sls_config_plugins }}
    - require_in:
      - sls: {{ sls_config_users }}

            {%- endfor %}
        {%- endif %}
    {%- endfor %}
