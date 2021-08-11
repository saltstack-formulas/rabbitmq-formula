# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}

    {%- for name, node in rabbitmq.nodes.items() %}
        {%- if 'clustered' in node and node.clustered %}

rabbitmq-config-clusters-{{ name }}-reset:
  cmd.run:
    - names:
      - /usr/sbin/rabbitmqctl --node {{ name }} stop_app || true
      - /usr/sbin/rabbitmqctl --node {{ name }} reset || true
      - /usr/sbin/rabbitmqctl --node {{ name }} start_app || true
      - /usr/sbin/rabbitmqctl --node {{ name }} cluster_status || true
    - runas: rabbitmq
    - onlyif:
      - test -x /usr/sbin/rabbitmqctl
      - test -d {{ rabbitmq.dir.data }}

        {%- endif %}
    {%- endfor %}
