{% for name, queue in salt["pillar.get"]("rabbitmq:queues", {}).iteritems() %}
rabbitmq_queue_{{ name }}:
  rabbitmq_queue.present:
    - name: {{ queue.name }}
    - vhost: {{ queue.vhost }}
    - durable: {{ queue.durable }}
    - auto_delete: {{ queue.auto_delete }}
    - require:
      - service: rabbitmq-server
{% endfor %}
