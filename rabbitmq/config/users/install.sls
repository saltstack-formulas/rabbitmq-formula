# -*- coding: utf-8 -*-
# vim: ft=sls
---
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}
{%- set sls_service_running = tplroot ~ '.service.running' %}
{%- set sls_vhosts_install = tplroot ~ '.config.vhosts.install' %}
{%- set cmd = '/usr/sbin/rabbitmqctl' %}

include:
  - {{ sls_service_running }}
  - {{ sls_vhosts_install }}

    {%- for name, node in salt["pillar.get"]("rabbitmq:nodes", {}).items() %}
        {%- if 'users' in node and node.users is mapping %}
            {%- for user, u in node.users.items() %}

rabbitmq-config-users-added-{{ name }}-{{ user }}:
  cmd.run:
    - names:
      - {{ cmd }} --node {{ name }} add_user {{ user }} {{ u.password }} |true
          {%- if 'force' in u and u.force %}
      - {{ cmd }} --node {{ name }} change_password {{ user }} {{ u.password }}
          {%- endif %}
          {%- if 'tags' in u and u.tags %}
      - {{ cmd }} --node {{ name }} set_user_tags {{ user }} {{ u.tags|join(' ') }}   # noqa 204
          {%- endif %}
          {%- if 'perms' in u and u.perms %}
              {%- for vhost, perms in u.perms.items() %}
      - {{ cmd }} --node {{ name }} set_permissions -p {{ vhost }} {{ user }} {{ perms|map("json")|join(" ") }}  # noqa 204
              {%- endfor %}
          {%- endif %}
    - onlyif: test -x {{ cmd }}
    - runas: rabbitmq
    - require:
      - sls: {{ sls_service_running }}
      - sls: {{ sls_vhosts_install }}

            {%- endfor %}
        {%- endif %}
    {%- endfor %}

    {% if salt['pillar.get']('rabbitmq:remove_guest_user', True) %}

rabbitmq-config-users-guest-absent:
  rabbitmq_user.absent:
    - name: guest

    {% endif %}
