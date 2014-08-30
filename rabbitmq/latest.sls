{% if grains['os_family'] == 'Debian' %}

include:
  - rabbitmq

rabbitmq_repo:
  pkgrepo.managed:
    - humanname: RabbitMQ Repository
    - name: deb http://www.rabbitmq.com/debian/ testing main
    - file: /etc/apt/sources.list.d/rabbitmq.list
    - key_url: http://www.rabbitmq.com/rabbitmq-signing-key-public.asc
    - require_in:
      - pkg: rabbitmq-server

{% endif %}