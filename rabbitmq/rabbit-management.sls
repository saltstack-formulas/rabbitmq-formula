# install into /usr/sbin so that it is in the path

install_rabbit_management:
  cmd.run:
    - name : curl -k -L http://localhost:15672/cli/rabbitmqadmin -o /usr/sbin/rabbitmqadmin



chmod_rabbit_management:
  file.managed:
  - name: /usr/sbin/rabbitmqadmin
  - user: root
  - group: root
  - mode: 755
  - require:
    - cmd : install_rabbit_management
