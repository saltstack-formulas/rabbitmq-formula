include:
  - rabbitmq

{% if grains['os_family'] == 'Debian' %}
{%   set pkg_dep_pyver = '3' if grains.pythonversion[0] == 3 else '' %}
rabbitmq_repo_pkg_deps:
  pkg.installed:
    - name: python{{ pkg_dep_pyver }}-apt
    - require_in:
      - pkgrepo: erlang_repo
      - pkgrepo: rabbitmq_repo
# TODO: install specific Erlang and RabbitMQ releases (see https://www.rabbitmq.com/install-debian.html)
erlang_repo:
  pkgrepo.managed:
    - humanname: Erlang from CloudSmith Repository
    - name: deb https://dl.cloudsmith.io/public/rabbitmq/rabbitmq-erlang/deb/debian {{ salt['grains.get']('oscodename') }} main
    - file: /etc/apt/sources.list.d/erlang.list
    - key_url: https://dl.cloudsmith.io/public/rabbitmq/rabbitmq-erlang/gpg.E495BB49CC4BBE5B.key
    - require_in:
      - pkg: rabbitmq-server
rabbitmq_repo:
  pkgrepo.managed:
    - humanname: RabbitMQ PackageCloud Repository
    - name: deb https://packagecloud.io/rabbitmq/rabbitmq-server/debian/ {{ salt['grains.get']('oscodename') }} main
    - file: /etc/apt/sources.list.d/rabbitmq.list
    - key_url: https://packagecloud.io/rabbitmq/rabbitmq-server/gpgkey
    - require_in:
      - pkg: rabbitmq-server
remove_old_erlang_repo:
  pkgrepo.absent:
    - name: deb https://dl.bintray.com/rabbitmq-erlang/debian {{ salt['grains.get']('oscodename') }} erlang
remove_old_rabbitmq_repo:
  pkgrepo.absent:
    - name: deb https://dl.bintray.com/rabbitmq/debian {{ salt['grains.get']('oscodename') }} main
{% elif grains['os'] == 'CentOS' and grains['osmajorrelease'][0] == '6' %}
rabbitmq_repo:
  pkgrepo.managed:
    - humanname: RabbitMQ Packagecloud Repository
    - baseurl: https://packagecloud.io/rabbitmq/rabbitmq-server/el/6/$basearch
    - gpgcheck: 1
    - enabled: True
    - gpgkey: https://packagecloud.io/gpg.key
    - sslverify: 1
    - sslcacert: /etc/pki/tls/certs/ca-bundle.crt
    - require_in:
      - pkg: rabbitmq-server
{% endif %}
