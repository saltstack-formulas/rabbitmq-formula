# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}
{%- set sls_repo_clean = tplroot ~ '.package.repo.clean' %}

include:
  - {{ sls_repo_clean }}

rabbitmq-package-clean-pkg-removed:
  pkg.removed:
    - name: {{ rabbitmq.pkg.name }}
    - require:
      - sls: {{ sls_repo_clean }}
  file.absent:
    - names: {{ rabbitmq.dir.cleanlist or ['/tmp/silly_321.out',] }}
