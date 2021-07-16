# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}

    {%- if 'plugin' in rabbitmq and rabbitmq.plugin is mapping %}
        {%- for name in rabbitmq.plugin %}

rabbitmq-config-plugin-disabled-{{ name }}:
  rabbitmq_plugin.disabled:
    - name: {{ name }}
    - runas: {{ rabbitmq.plugin[name]['runas'] }}

        {%- endfor %}
    {%- endif %}
