
rabbitmq_user:
  user.present:
    - name: rabbitmq
    - home: /opt/rabbitmq

rabbitmq_dir:
  file.directory:
    - name: /opt/rabbitmq
    - user: rabbitmq
    - group: rabbitmq
    - makedirs: true
    - require:
      - user: rabbitmq
