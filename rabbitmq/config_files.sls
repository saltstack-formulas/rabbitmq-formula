# Should have a place to specify config directory per distrib?
include:
  - .install

{%- for filename, info in salt["pillar.get"]("rabbitmq:config_files", {}).items() %}
  {%- set source = info['source'] %}
/etc/rabbitmq/{{ filename }}:
  file.managed:
    {%- if source.startswith('salt://') %}
    - source: {{ source }}
    {%- else %}
    - source: salt://{{ slspath }}/{{ source }}
    {% endif %}
    - template: jinja
    - context: {{ info.get('context', {})|json }}
    - watch_in:
      - service: rabbitmq-server
{% endfor %}
