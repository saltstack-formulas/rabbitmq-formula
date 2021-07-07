# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}
{%- set sls_config_plugin = tplroot ~ '.config.plugin.install' %}

include:
  - {{ sls_config_plugin }}

rabbitmq-rabbitmqadmin-install:
  cmd.run:
    - name : curl -k -L http://localhost:15672/cli/rabbitmqadmin -o /usr/local/sbin/rabbitmqadmin
    - require:
      - sls: {{ sls_config_plugin }}
  file.managed:
   - name: /usr/local/sbin/rabbitmqadmin
   - user: root
   - force: false
   - replace: false
   - group: {{ rabbitmq.id.rootgroup }}
   - mode: 755
   - require:
     - cmd : rabbitmq-rabbitmqadmin-install
