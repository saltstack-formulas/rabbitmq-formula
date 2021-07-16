# -*- coding: utf-8 -*-
# vim: ft=sls
---
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}

    {%- for name, node in salt["pillar.get"]("rabbitmq:nodes", {}).items() %}
        {%- if 'users' in node and node.users is mapping %}
            {%- for user, items in node.users.items() %}

rabbitmq-config-users-deleted-{{ user }}:
  cmd.run:
    - name: /usr/sbin/rabbitmq --node {{ name }} delete_user {{ items.user }} |true
    - onlyif: test -x /usr/sbin/rabbitmqctl
    - runas: rabbitmq

            {%- endfor %}
        {%- endif %}
    {%- endfor %}
