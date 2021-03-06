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

rabbitmq-package-repo-erlang:
  pkgrepo.managed:
    # using cloudsmith.io for rabbitmq-erlang (recommended)
    - name: deb https://dl.cloudsmith.io/public/rabbitmq/rabbitmq-erlang/deb/ubuntu bionic main
    - humanname: Erlang from CloudSmith Repository
      # "ubuntu:bionic" as distribution may work for recent Ubuntu or Debian release
    - file: /etc/apt/sources.list.d/erlang.list
    - key_url: https://dl.cloudsmith.io/public/rabbitmq/rabbitmq-erlang/gpg.E495BB49CC4BBE5B.key
    - require_in:
      - pkg: rabbitmq-package-install-pkg-installed

rabbitmq-package-repo-rabbitmq:
  pkgrepo.managed:
    # using packagecloud for rabbitmq-server (recommended)
    - name: deb https://packagecloud.io/rabbitmq/rabbitmq-server/ubuntu bionic main
    - humanname: RabbitMQ PackageCloud Repository
       # https://www.rabbitmq.com/install-debian.html#apt
       # "bionic" as distribution name should work for any reasonably recent Ubuntu or Debian release.
       # See the release to distribution mapping table in RabbitMQ doc guides to learn more.
    - file: /etc/apt/sources.list.d/rabbitmq.list
    - key_url: https://packagecloud.io/rabbitmq/rabbitmq-server/gpgkey
    - require_in:
      - pkg: rabbitmq-package-install-pkg-installed

            {% elif grains['os_family'] == 'RedHat' %}

rabbitmq-package-repo-erlang:
  pkgrepo.managed:
    - name: rabbitmq_rabbitmq-server
    # using cloudsmith.io for rabbitmq-erlang (recommended)
    - baseurl: https://dl.cloudsmith.io/public/rabbitmq/rabbitmq-erlang/rpm/el/{{ grains.osmajorrelease }}/$basearch
    - gpgkey: https://dl.cloudsmith.io/public/rabbitmq/rabbitmq-erlang/gpg.E495BB49CC4BBE5B.key
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
    - name: rabbitmq-rabbitmq
    # using packagecloud for rabbitmq-server (recommended)
    - baseurl: https://packagecloud.io/rabbitmq/rabbitmq-server/el/{{ grains.osmajorrelease }}/$basearch
    - gpgkey: https://packagecloud.io/rabbitmq/rabbitmq-server/gpgkey
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
