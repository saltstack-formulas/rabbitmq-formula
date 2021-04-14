# -*- coding: utf-8 -*-
# vim: ft=sls
---
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}

    {%- if rabbitmq.pkg.use_upstream|lower == 'repo' %}
        {%- if grains.os_family in ('RedHat', 'Debian') %}
            {%- set sls_package_clean = tplroot ~ '.package.clean' %}

include:
  - {{ sls_package_clean }}

rabbitmq-package-repo-erlang-clean:
  pkgrepo.absent:
    - names:
      - rabbitmq-rabbitmq-erlang
      - rabbitmq_rabbitmq-erlang
      - rabbitmq-rabbitmq
      - rabbitmq_rabbitmq-server
      - deb https://dl.bintray.com/rabbitmq-erlang/debian {{ salt['grains.get']('oscodename') }} erlang
      - deb https://dl.bintray.com/rabbitmq/debian {{ salt['grains.get']('oscodename') }} main
    - require_in:
      - pkg: rabbitmq-package-clean-pkg-removed
  file.absent:
    - name: /var/cache/dnf/rabbitmq*

        {%- else %}

rabbitmq-package-repo-clean-unavailable:
  test.show_notification:
    - name: Skipping repository configuration
    - text: |
        At the moment, there's no repo for {{ grains['os'] }}

        {%- endif %}
    {%- else %}

rabbitmq-package-repo-clean-deselected:
  test.show_notification:
    - name: Skipping repository configuration
    - text: |
        Using Linux distribution package for RabbitMQ (not upstream repo)

    {% endif %}
