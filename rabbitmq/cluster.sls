{% from "rabbitmq/map.jinja" import rabbitmq with context %}

{%- set cluster = salt['pillar.get']('rabbitmq:cluster') %}
{%- if cluster %}
include:
  - .install

rabbitmq-hosts-file:
  file.blockreplace:
    - name: /etc/hosts
    - content: |
      
    {%- for alias, fqdn in cluster.get('members', {}).items() %}
        {{ (salt['dnsutil.A'](fqdn)[0] + ' ' + fqdn + ' ' + alias) | indent(8) }} 
    {%- endfor %}
    - append_if_not_found: True
    - show_changes: True
    - marker_start: "# Salt RabbitMQ START"
    - marker_end: "# Salt RabbitMQ END"
    - watch_in:
      - service: rabbitmq-server

rabbitmq-config-dir:
  file.directory:
    - name: /etc/rabbitmq
    - user: {{ rabbitmq.config.user }}
    - group: {{ rabbitmq.config.group }}
    # Setting gid sticky bit to avoid issues with plugin management.
    - mode: 2755

rabbitmq-config-file:
  file.managed:
    - name: /etc/rabbitmq/rabbitmq.config
    - source: salt://{{ slspath }}/files/rabbitmq.config.j2
    - user: {{ rabbitmq.config.user }}
    - group: {{ rabbitmq.config.group }}
    - mode: 0644
    - template: jinja
    - require:
      - file: rabbitmq-config-dir
    - watch_in:
      - service: rabbitmq-server
    - require_in:
      - pkg: rabbitmq-server

rabbitmq-set-cookie:
  file.managed:
    - name: /var/lib/rabbitmq/.erlang.cookie
    - user: {{ rabbitmq.config.user }}
    - group: {{ rabbitmq.config.group }}
    - mode: 0400
    - contents_pillar: rabbitmq:cluster:cookie
    - watch_in:
      - service: rabbitmq-server
    - require_in:
      - pkg: rabbitmq-server
    - require:
      - user: rabbitmq-user
      - group: rabbitmq-group

{%- endif %}