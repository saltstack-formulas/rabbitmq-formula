{% from "rabbitmq/map.jinja" import rabbitmq with context %}


{% set module_list = salt['sys.list_modules']() %}
{% if 'rabbitmqadmin' in module_list %}
include:
  - .config_bindings
  - .config_queue
  - .config_exchange
{% endif %}

rabbitmq-user:
  user.present:
    - name: {{ rabbitmq.config.user }}
    - fullname: RabbitMQ messaging server
    - home: /var/lib/rabbitmq
    - system: True
    - shell: /sbin/nologin
    - gid_from_name: rabbitmq
    {%- for property, value in rabbitmq.config.user_properties.items() %}
    - {{ property }}: {{ value }}
    {%- endfor %}
    - require:
      - group: rabbitmq
    - watch_in:
      - service: rabbitmq-server

rabbitmq-group:
  group.present:
    - name: {{ rabbitmq.config.group }}
    - system: True

rabbitmq-server:
  pkg.installed:
    - name: {{ rabbitmq.pkg }}
    {%- if 'version' in salt['pillar.get']('rabbitmq', {}) %}
    - version: {{ salt['pillar.get']('rabbitmq:version') }}
    {%- endif %}

  service:
    - {{ "running" if salt['pillar.get']('rabbitmq:running', True) else "dead" }}
    - enable: {{ salt['pillar.get']('rabbitmq:enabled', True) }}
    - watch:
      - pkg: rabbitmq-server

rabbitmq_binary_tool_env:
  file.symlink:
    - makedirs: True
    - name: /usr/local/bin/rabbitmq-env
    - target: /usr/lib/rabbitmq/bin/rabbitmq-env
    - require:
      - pkg: rabbitmq-server

rabbitmq_binary_tool_plugins:
  file.symlink:
    - makedirs: True
    - name: /usr/local/bin/rabbitmq-plugins
    - target: /usr/lib/rabbitmq/bin/rabbitmq-plugins
    - require:
      - pkg: rabbitmq-server
      - file: rabbitmq_binary_tool_env

