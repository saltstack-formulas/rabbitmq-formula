# -*- coding: utf-8 -*-
# vim: ft=sls
---
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}

    {%- for name, node in rabbitmq.nodes.items() %}
        {%- if 'queues' in node and node.queues is mapping %}
            {%- for queue, q in node.queues.items() %}

rabbitmq-config-queues-disabled-{{ name }}-{{ queue }}:
  cmd.run:
    - name: /usr/local/sbin/rabbitmqadmin --node {{ name }} delete queue --vhost={{ q.vhost }} --username={{ q.user }} --password={{ q.passwd }} name={{ queue }}  # noqa 204
    - onlyif:
      - test -x /usr/local/sbin/rabbitmqadmin
      - test -d {{ rabbitmq.dir.data }}
    - runas: rabbitmq

            {%- endfor %}
        {%- endif %}
    {%- endfor %}
