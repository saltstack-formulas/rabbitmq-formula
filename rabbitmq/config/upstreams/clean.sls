# -*- coding: utf-8 -*-
# vim: ft=sls
---
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}

    {%- for name, node in rabbitmq.nodes.items() %}
        {%- if 'upstreams' in node and node.upstreams is mapping %}
            {%- for upstream, p in node.upstreams.items() %}

rabbitmq-config-upstreams-absent-{{ name }}-{{ upstream }}:
  rabbitmq_upstream.absent:
                {%- for l in p %}
    - {{ l|yaml }}
                {%- endfor %}
    - runas: rabbitmq
    - onlyif:
      - test -x /usr/sbin/rabbitmqctl
      - test -d {{ rabbitmq.dir.data }}

            {%- endfor %}
        {%- endif %}
    {%- endfor %}
