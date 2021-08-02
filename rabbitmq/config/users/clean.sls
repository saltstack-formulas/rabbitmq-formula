# -*- coding: utf-8 -*-
# vim: ft=sls
---
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as r with context %}
{%- set sls_service_clean = tplroot ~ '.service.clean' %}

include:
  - {{ sls_service_clean }}

    {%- if grains.os_family == 'RedHat' and 'locale_all' in r.environ %}

rabbitmq-config-users-environ-locale:
  environ.setenv:
    - name: LC_ALL
    - value: {{ 'en_US.UTF-8' if 'locale_all' not in r.environ else r.environ.locale_all }}
    - update_minion: True

    {%- endif %}
    {%- for name, node in r.nodes.items() %}
        {%- if 'users' in node and node.users is mapping %}
            {%- for user, items in node.users.items() %}

rabbitmq-config-users-delete-{{ name }}-{{ user }}:
  cmd.run:
    - name: /usr/sbin/rabbitmqctl --node {{ name }} delete_user {{ user }} ||true
    - onlyif:
      - test -x /usr/sbin/rabbitmqctl
      - test -d {{ r.dir.data }}
    - runas: rabbitmq
    - require_in:
      - sls: {{ sls_service_clean }}

            {%- endfor %}
        {%- endif %}
    {%- endfor %}
