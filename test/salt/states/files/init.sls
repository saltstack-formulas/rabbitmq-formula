
rabbitmq_user:
  user.present:
    - name: rabbitmq
    - home: /var/lib/rabbitmq

rabbitmq_dir:
  file.directory:
    - name: /var/lib/rabbitmq
    - user: rabbitmq
    - group: rabbitmq
    - makedirs: true
    - require:
      - user: rabbitmq
