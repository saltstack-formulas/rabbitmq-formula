# -*- coding: utf-8 -*-
# vim: ft=sls
---
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}
{%- set sls_service_running = tplroot ~ '.service.running' %}

include:
  - {{ sls_service_running }}

    {%- for name, node in salt["pillar.get"]("rabbitmq:nodes", {}).items() %}
        {%- if 'plugins' in node and node.plugins is iterable and node.plugins is not string %}
            {%- for plugin in node.plugins %}

rabbitmq-config-plugins-enabled-{{ name }}-{{ plugin }}:
  cmd.run:
    - name: /usr/sbin/rabbitmq-plugins --node {{ name }} enable {{ plugin }}
    - runas: root
    - onlyif: test -x /usr/sbin/rabbitmqctl
    - watch_in:
      - service: rabbitmq-service-running-service-running-{{ name }}

                {%- if plugin == 'rabbitmq_management' %}

rabbitmq-config-plugins-{{ name }}-rabbitmqadmin-install:
  cmd.run:
    - name : curl -k -L http://localhost:15672/cli/rabbitmqadmin -o /usr/local/sbin/rabbitmqadmin
  file.managed:
   - name: /usr/local/sbin/rabbitmqadmin
   - user: root
   - force: false
   - replace: false
   - group: {{ rabbitmq.rootgroup }}
   - mode: 755
   - require:
     - cmd : rabbitmq-config-plugins-{{ name }}-rabbitmqadmin-install

                {%- endif %}

            {%- endfor %}
        {%- endif %}
    {%- endfor %}
