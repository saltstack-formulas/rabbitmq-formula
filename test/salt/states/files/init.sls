
rabbitmq_user:
  user.present:
    - name: rabbitmq
    - home: /var/lib/rabbitmq

rabbitmq_dir:
  file.directory:
    - name: /var/lib/rabbitmq
    - user: rabbitmq
    - group: {{ 'rabbitmq' if grains.os_family != 'Suse' else 'users' }}
    - makedirs: true
    - require:
      - user: rabbitmq
