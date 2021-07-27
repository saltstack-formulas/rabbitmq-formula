# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}

    {%- for name, node in rabbitmq.nodes.items() %}
        {%- if 'clustered' in node and node.clustered and 'join_node' in node %}

rabbitmq-config-clusters-{{ name }}-leave-{{ node.join_node }}:
  cmd.run:
    - names:
      - /usr/sbin/rabbitmqctl --node {{ name }}@localhost stop_app || true
      - /usr/sbin/rabbitmqctl --node {{ name }}@localhost reset || true
      - /usr/sbin/rabbitmqctl --node {{ name }}@localhost start_app || true
      - /usr/sbin/rabbitmqctl --node {{ name }}@localhost cluster_status || true
    - runas: rabbitmq
    - onlyif: test -x /usr/sbin/rabbitmqctl
  file.absent:
    - name: {{ rabbitmq.dir.data }}/{{ name }}/.erlang.cookie
    - require:
      - cmd: rabbitmq-config-clusters-{{ name }}-leave-{{ node.join_node }}

        {%- endif %}
    {%- endfor %}
