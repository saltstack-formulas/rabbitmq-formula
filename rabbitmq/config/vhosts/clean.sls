# -*- coding: utf-8 -*-
# vim: ft=sls
---
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}

    {%- for name, node in salt["pillar.get"]("rabbitmq:nodes", {}).items() %}
        {%- if 'vhosts' in node and node.vhosts is iterable and node.vhosts is not string %}
            {%- for vhost in node.vhosts %}

rabbitmq-config-vhosts-delete-{{ name }}-{{ vhost }}:
  cmd.run:
    - name: /usr/sbin/rabbitmqctl --node {{ name }} delete_vhost {{ vhost }} || true
    - onlyif: test -x /usr/sbin/rabbitmqctl
    - runas: rabbitmq

            {%- endfor %}
        {%- endif %}
    {%- endfor %}
