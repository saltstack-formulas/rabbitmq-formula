{% from "rabbitmq/map.jinja" import rabbitmq with context %}

include:
- .install

{% for name, plugin in salt["pillar.get"]("rabbitmq:plugin", {}).items() %}
{{ name }}:
  rabbitmq_plugin:
    {% for value in plugin %}
    - {{ value }}
    {% endfor %}
    - runas: root
    - require:
      - pkg: rabbitmq-server
      - file: rabbitmq_binary_tool_plugins
    - watch_in:
      - service: rabbitmq-server
{% endfor %}

{% for name, policy in salt["pillar.get"]("rabbitmq:policy", {}).items() %}
{%- set depend = {} %}
{{ name }}:
  rabbitmq_policy.present:
    {%- for value in policy %}
    - {{ value }}
    {%- if 'vhost' in value.keys() %}
    {% do depend.update(value) %}
    {%- endif %}
    {% endfor %}
    - require:
      - service: rabbitmq-server
      {%- if depend.get('vhost', None)  %}
      - rabbitmq_vhost: rabbitmq_vhost_{{ depend.get('vhost') }}
      {%- endif %}
{% endfor %}

{% for name, vhost in salt["pillar.get"]("rabbitmq:vhost", {}).items() %}
rabbitmq_vhost_{{ vhost }}:
  rabbitmq_vhost.present:
    - name: {{ vhost }}
    - require:
      - service: rabbitmq-server
{% endfor %}

{% for name, user in salt["pillar.get"]("rabbitmq:user", {}).items() %}
rabbitmq_user_{{ name }}:
  rabbitmq_user.present:
    - name: {{ name }}
    {% for value in user %}
    - {{ value }}
    {% endfor %}
    - require:
      - service: rabbitmq-server
{% endfor %}
