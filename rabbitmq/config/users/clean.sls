# -*- coding: utf-8 -*-
# vim: ft=sls
---
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}

    {%- if grains.os_family == 'RedHat' and rabbitmq.environ.locale_all %}

rabbitmq-config-users-environ-locale:
  environ.setenv:
    - name: LC_ALL
    - value: {{ rabbitmq.environ.locale_all }}
    - update_minion: True

    {%- endif %}
    {%- for name, node in salt["pillar.get"]("rabbitmq:nodes", {}).items() %}
        {%- if 'users' in node and node.users is mapping %}
            {%- for user, items in node.users.items() %}

rabbitmq-config-users-deleted-{{ name }}-{{ user }}:
  cmd.run:
    - name: /usr/sbin/rabbitmqctl --node {{ name }} delete_user {{ user }} |true
    - onlyif: test -x /usr/sbin/rabbitmqctl
    - runas: rabbitmq

            {%- endfor %}
        {%- endif %}
    {%- endfor %}
