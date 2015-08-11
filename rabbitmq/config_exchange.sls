{% for name, exchange in salt["pillar.get"]("rabbitmq:exchanges", {}).iteritems() %}
rabbitmq_exchange_{{ name }}:
  rabbitmq_exchange.present:
    - name: {{ exchange.name }}
    - vhost: {{ exchange.vhost }}
    - typename: {{ exchange.type }}
    - durable: {{ exchange.durable }}
    - auto_delete: {{ exchange.auto_delete }}
    - internal: {{ exchange.internal }}
    - require:
      - service: rabbitmq-server
{% endfor %}
