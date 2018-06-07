# Should have a place to specify config directory per distrib?
include:
  - .install

{% for filename, info in salt["pillar.get"]("rabbitmq:config_files", {}).items() %}
/etc/rabbitmq/{{ filename }}:
  file.managed:
    - source: salt://{{ slspath }}/{{ info['source'] }}
    - template: jinja
    - context: {{ info.get('context', {})|json }}
    - watch_in:
      - service: rabbitmq-server
{% endfor %}
