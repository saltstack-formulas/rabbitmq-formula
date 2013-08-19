{% from "rabbitmq/package-map.jinja" import pkgs with context %}

rabbitmq-server:
  pkg.installed:
    - name: {{ pkgs['rabbitmq-server'] }}
  service:
    - running
    - enable: True
    - watch:
      - pkg: rabbitmq-server
