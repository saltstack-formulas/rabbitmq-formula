# -*- coding: utf-8 -*-
# vim: ft=sls
---
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}
{%- set sls_service_running = tplroot ~ '.service.running' %}
{%- set cmd = '/usr/sbin/rabbitmqctl' %}

include:
  - {{ sls_service_running }}

    {%- for name, node in salt["pillar.get"]("rabbitmq:nodes", {}).items() %}
        {%- if 'users' in node and node.users is mapping %}
            {%- for user, items in node.users.items() %}

rabbitmq-config-users-added-{{ user }}:
  cmd.run:
    - names:
      - {{ cmd }} --node {{ name }} add_user {{ items.user }} {{ items.passwd }} |true
          {%- if 'force' in items and items.force %}
      - {{ cmd }} --node {{ name }} change_password {{ items.user }} {{ items.passwd }}
          {%- endif %}
          {%- if 'tags' in items and items.tags %}
      - {{ cmd }} --node {{ name }} set_user_tags {{ items.user }} {{ items.tags|join(' ') }}   # noqa 204
          {%- endif %}
          {%- if 'perms' in items and items.perms %}
              {%- for vhost, perms in items.perms.items() %}
      - {{ cmd }} --node {{ name }} set_permissions -p {{ vhost }} {{ items.user }} {{ perms|join(' ') }}  # noqa 204
              {%- endfor %}
          {%- endif %}
    - onlyif: test -x {{ cmd }}
    - runas: rabbitmq
    - require:
      - sls: {{ sls_service_running }}

            {%- endfor %}
        {%- endif %}
    {%- endfor %}

    {% if salt['pillar.get']('rabbitmq:remove_guest_user', True) %}

rabbitmq-config-users-guest-absent:
  rabbitmq_user.absent:
    - name: guest

    {% endif %}
