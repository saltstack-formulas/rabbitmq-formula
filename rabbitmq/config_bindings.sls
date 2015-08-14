{% for name, binding in salt["pillar.get"]("rabbitmq:bindings", {}).iteritems() %}
rabbitmq_binding_{{ name }}:
  rabbitmq_binding.present:
    - source: {{ binding.source }}
    - vhost: {{ binding.vhost }}
    - destination: {{ binding.destination }}
    - destination_type: {{ binding.destination_type }}
    - routing_key: {{ binding.routing_key }}
    - require:
      - service: rabbitmq-server
{% endfor %}
