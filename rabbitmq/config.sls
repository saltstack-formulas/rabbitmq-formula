{% for name, plugin in salt["pillar.get"]("rabbitmq:plugin", {}).iteritems() %}
{{ name }}:
  rabbitmq_plugin:
    {% for value in plugin %}
    - {{ value }}
    {% endfor %}
    - require:
      - pkg: rabbitmq-server
      - file: rabbitmq_binary_tool_plugins
{% endfor %}

{% for name, policy in salt["pillar.get"]("rabbitmq:policy", {}).iteritems() %}
{{ name }}:
  rabbitmq_policy.present:
    {% for value in policy %}
    - {{ value }}
    {% endfor %}
    - require:
      - service: rabbitmq-server
{% endfor %}

{% for name, policy in salt["pillar.get"]("rabbitmq:vhost", {}).iteritems() %}
{{ name }}:
  rabbitmq_vhost.present:
    {% for value in policy %}
    - {{ value }}
    {% endfor %}
    - require:
      - service: rabbitmq-server
{% endfor %}

{% for name, policy in salt["pillar.get"]("rabbitmq:user", {}).iteritems() %}
{{ name }}:
  rabbitmq_user.present:
    {% for value in policy %}
    - {{ value }}
    {% endfor %}
    - require:
      - service: rabbitmq-server
{% endfor %}
