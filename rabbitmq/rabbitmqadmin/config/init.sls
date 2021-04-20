# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set module_list = salt['sys.list_modules']() %}
{% if 'rabbitmqadmin' in module_list %}

include:
  - .binding
  - .exchange
  - .queue

{%- endif %}
