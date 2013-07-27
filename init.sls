rabbitmq-server:
{% if grains['os_family'] == 'Debian' %}
  pkg.installed:
    - name: rabbitmq-server
  service:
    - running
    - enable: True
{% endif %}
