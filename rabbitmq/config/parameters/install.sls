# -*- coding: utf-8 -*-
# vim: ft=sls
---
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}
{%- set sls_service_running = tplroot ~ '.service.running' %}

include:
  - {{ sls_service_running }}

    {%- for name, node in rabbitmq.nodes.items() %}
        {%- if 'parameters' in node and node.parameters is mapping %}
            {%- for param, p in node.parameters.items() %}

rabbitmq-config-parameters-present-{{ name }}-{{ param }}:
  cmd.run:
    - name: >-
                {%- if p.component == 'federation-upstream' %}
            /usr/sbin/rabbitmqctl --node {{ name }} set_parameter --vhost={{ '/' if 'vhost' not in p else p.vhost }} {{ p.component }} '{{ param }}' '{{ p.definition|json }}'  # noqa 204
                {%- else %}{# federation-upstream-set for now #}
            /usr/sbin/rabbitmqctl --node {{ name }} set_parameter --vhost={{ '/' if 'vhost' not in p else p.vhost }} {{ p.component }} '{{ param }}' '[{{ p.definition|json }},]'  # noqa 204
                {%- endif %}
    - runas: rabbitmq
    - onlyif: test -x /usr/sbin/rabbitmqctl
    - require:
      - service: rabbitmq-service-running-service-running-{{ name }}

            {%- endfor %}
        {%- endif %}
    {%- endfor %}
