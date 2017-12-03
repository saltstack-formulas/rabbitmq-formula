{% from "rabbitmq/map.jinja" import rabbitmq with context %}

stop-rabbitmq-server:
  service.dead:
    - name: rabbitmq-server

uninstall-rabbitmq-package:
  pkg.purged:
    - name: {{ rabbitmq.pkg }}
    - require:
      - service: stop-rabbitmq-server

remove-rabbitmq-files:
  file.absent:
    - name: /var/lib/rabbitmq
    - require:
      - pkg: uninstall-rabbitmq-package

remove-rabbitmq-logs:
  file.absent:
    - name: /var/log/rabbitmq
    - require:
      - pkg: uninstall-rabbitmq-package

remove-rabbitmq-config:
  file.absent:
    - name: /etc/rabbitmq
    - require:
      - pkg: uninstall-rabbitmq-package

remove-rabbitmq-user:
  user.absent:
    - name: rabbitmq
    - require:
      - file: remove-rabbitmq-config

remove-rabbitmq-group:
  group.absent:
    - name: rabbitmq
    - require:
      - user: rabbitmq




