# -*- coding: utf-8 -*-
# vim: ft=sls
---
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}

    {%- if rabbitmq.pkg.use_upstream|lower == 'repo' %}
        {%- if grains.os_family in ('RedHat', 'Debian') %}
            {%- set sls_package_install = tplroot ~ '.package.install' %}

include:
  - {{ sls_package_install }}

            {%- if grains.os_family == 'Debian' %}

rabbitmq-package-repo-pkg-deps:
  pkg.installed:
    - name: python{{ grains.pythonversion[0] or '' }}-apt
    - require_in:
      - pkgrepo: rabbitmq-package-repo-erlang
      - pkgrepo: rabbitmq-package-repo-rabbitmq

{%- set osname = grains['os'] %}
{%- set oscodename = grains['oscodename'] %}

rabbitmq-package-repo-erlang:
  pkgrepo.managed:
    - name: deb {{ rabbitmq.pkg.repo.erlang.url }}/{{ osname|lower }} {{ oscodename }} main
    - file: /etc/apt/sources.list.d/erlang.list
    - key_url: {{ rabbitmq.pkg.repo.erlang.key_url }}
    - require_in:
      - pkg: rabbitmq-package-install-pkg-installed

rabbitmq-package-repo-rabbitmq:
  pkgrepo.managed:
    - name: deb {{ rabbitmq.pkg.repo.rabbitmq.url }}/{{ osname|lower }} {{ oscodename }} main
    - file: /etc/apt/sources.list.d/rabbitmq.list
    - key_url: {{ rabbitmq.pkg.repo.rabbitmq.key_url }}
    - require_in:
      - pkg: rabbitmq-package-install-pkg-installed

            {% elif grains['os_family'] == 'RedHat' %}
              {%- if grains['os'] == 'Amazon' %}
                {%- set releasever = salt['cmd.run']("rpm -E '%{rhel}'") %}
              {%- else %}
                {%- set releasever = grains['osmajorrelease'] %}
              {%- endif %}

rabbitmq-package-repo-erlang:
  pkgrepo.managed:
    - name: rabbitmq_erlang
    - baseurl: {{ rabbitmq.pkg.repo.erlang.baseurl }}/{{ releasever }}/$basearch
    - gpgkey: {{ rabbitmq.pkg.repo.erlang.gpgkey }}
    - repo_gpgcheck: 1
    - enabled: 1
    - gpgcheck: 0
    - sslverify: 1
    - sslcacert: /etc/pki/tls/certs/ca-bundle.crt
    - metadata_expire: 300
    - pkg_gpgcheck: 1
    - autorefresh: 1
    - type: rpm-md
    - require_in:
      - pkg: rabbitmq-package-install-pkg-installed

rabbitmq-package-repo-rabbitmq:
  pkgrepo.managed:
    - name: rabbitmq_rabbitmq-server
    - baseurl: {{ rabbitmq.pkg.repo.rabbitmq.baseurl }}/{{ releasever }}/$basearch
    - gpgkey: {{ rabbitmq.pkg.repo.rabbitmq.gpgkey }}
    - enabled: 1
    - gpgcheck: 0
    - sslverify: 1
    - repo_gpgcheck: 1
    - sslcacert: /etc/pki/tls/certs/ca-bundle.crt
    - metadata_expire: 300
    - pkg_gpgcheck: 1
    - autorefresh: 1
    - type: rpm-md
    - require_in:
      - pkg: rabbitmq-package-install-pkg-installed

            {%- endif %}
        {%- else %}

rabbitmq-package-repo-install-unavailable:
  test.show_notification:
    - name: Skipping repository configuration
    - text: |
        At the moment, there's no repo for {{ grains['os'] }}

        {%- endif %}
    {%- else %}

rabbitmq-package-repo-install-deselected:
  test.show_notification:
    - name: Skipping repository configuration
    - text: |
        Using Linux distribution package for RabbitMQ (not upstream repo)

    {% endif %}
