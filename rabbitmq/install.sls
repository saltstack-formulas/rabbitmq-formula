# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_file = tplroot ~ '.config.file' %}
{%- from tplroot ~ "/map.jinja" import rabbitmq with context %}

{% set module_list = salt['sys.list_modules']() %}
{% if 'rabbitmqadmin' in module_list %}
include:
  - .config_bindings
  - .config_queue
  - .config_exchange
{% endif %}

rabbitmq-server:
  pkg.installed:
    - pkgs: {{ rabbitmq.pkgs }}
    {%- if 'version' in salt['pillar.get']('rabbitmq', {}) %}
    - version: {{ salt['pillar.get']('rabbitmq:version') }}
    {%- endif %}

  service:
    - {{ "running" if salt['pillar.get']('rabbitmq:running', True) else "dead" }}
    - enable: {{ salt['pillar.get']('rabbitmq:enabled', True) }}
    - watch:
      - pkg: rabbitmq-server

rabbitmq_binary_tool_env:
  file.symlink:
    - makedirs: True
    - name: /usr/local/bin/rabbitmq-env
    - target: /usr/lib/rabbitmq/bin/rabbitmq-env
    - require:
      - pkg: rabbitmq-server

rabbitmq_binary_tool_plugins:
  file.symlink:
    - makedirs: True
    - name: /usr/local/bin/rabbitmq-plugins
    - target: /usr/lib/rabbitmq/bin/rabbitmq-plugins
    - require:
      - pkg: rabbitmq-server
      - file: rabbitmq_binary_tool_env

