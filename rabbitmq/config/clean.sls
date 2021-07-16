# -*- coding: utf-8 -*-
# vim: ft=sls
---
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}

include:
  - .file.clean

        {%- if salt['cmd.run']('test -f {0}/bin/rabbitmqctl'.format(rabbitmq.dir.base)) %}

  - .policy.clean
  - .plugin.clean
  - .upstream.clean
  - .queue.clean
  - .vhost.clean
  - .user.clean
  - .file.clean

        {%- endif %}
