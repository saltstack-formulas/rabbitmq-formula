{% from "rabbitmq/package-map.jinja" import pkgs with context %}

include:
  - .config

rabbitmq-server:
  pkg.installed:
    - name: {{ pkgs['rabbitmq-server'] }}
  service:
    - running
    - enable: True
    - watch:
      - pkg: rabbitmq-server

rabbitmq_binary_tool_env:
  file.symlink:
    - name: /usr/local/bin/rabbitmq-env
    - target: /usr/lib/rabbitmq/bin/rabbitmq-env
    - require:
      - pkg: rabbitmq-server

rabbitmq_binary_tool_plugins:
  file.symlink:
    - name: /usr/local/bin/rabbitmq-plugins
    - target: /usr/lib/rabbitmq/bin/rabbitmq-plugins
    - require:
      - pkg: rabbitmq-server
      - file: rabbitmq_binary_tool_env
