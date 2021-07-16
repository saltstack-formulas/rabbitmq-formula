# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}

    {%- for name, node in salt["pillar.get"]("rabbitmq:nodes", {}).items() %}
        {%- if node and 'clustered' in node and node.clustered %}

rabbitmq-config-clusters-{{ name }}-leave-{{ node.join_node }}:
  file.absent:
    - name: {{ rabbitmq.dir.data }}/{{ name }}/.erlang.cookie
  cmd.run:
    - names:
      - /usr/sbin/rabbitmqctl --node {{ name }} stop_app
      - /usr/sbin/rabbitmqctl --node {{ name }} reset
      - /usr/sbin/rabbitmqctl --node {{ name }} start_app
    - runas: rabbitmq
    - onlyif: test -x /usr/sbin/rabbitmqctl

        {%- endif %}
    {%- endfor %}
