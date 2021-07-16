# -*- coding: utf-8 -*-
# vim: ft=sls
---
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}

    {%- for name, node in salt["pillar.get"]("rabbitmq:nodes", {}).items() %}
        {%- if 'plugins' in node and node.plugins is iterable and node.plugins is not string %}
            {%- for plugin in node.plugins %}

rabbitmq-config-plugins-disabled-{{ name }}-{{ plugin }}:
  cmd.run:
    - name: /usr/sbin/rabbitmq-plugins --node {{ name }} disable {{ plugin }}
    - onlyif: test -x /usr/sbin/rabbitmqctl
    - runas: root
  file.absent:
    - name: /usr/local/sbin/rabbitmqadmin

            {%- endfor %}
        {%- endif %}
    {%- endfor %}
