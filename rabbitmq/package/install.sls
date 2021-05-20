# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}
{%- set sls_repo_install = tplroot ~ '.package.repo.install' %}

include:
  - {{ sls_repo_install }}

    {%- if rabbitmq.pkg.deps %}

rabbitmq-package-install-pkg-deps:
  pkg.installed:
    - names: {{ rabbitmq.pkg.deps|json }}

    {%- endif %}

rabbitmq-package-install-pkg-installed:
  pkg.installed:
    - env:
      - RABBITMQ_BASE: {{ rabbitmq.dir.base }}
    - name: {{ rabbitmq.pkg.name }}
    - require:
      - sls: {{ sls_repo_install }}

rabbitmq-package-install-pkg-binary-tool-env:
  file.symlink:
    - makedirs: True
    - name: /usr/local/bin/rabbitmq-env
    - target: {{ rabbitmq.dir.base }}/bin/rabbitmq-env
    - onlyif: test -f {{ rabbitmq.dir.base }}/bin/rabbitmq-env
    - require:
      - pkg: rabbitmq-package-install-pkg-installed

rabbitmq-package-install-pkg-binary-plugins:
  file.symlink:
    - makedirs: True
    - name: /usr/local/bin/rabbitmq-plugins
    - target: {{ rabbitmq.dir.base }}/bin/rabbitmq-plugins
    - onlyif: test -f {{ rabbitmq.dir.base }}/bin/rabbitmq-plugins
    - require:
      - pkg: rabbitmq-package-install-pkg-installed
