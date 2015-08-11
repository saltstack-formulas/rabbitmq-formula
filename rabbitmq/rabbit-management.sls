# rabbitmq-management-git :
#   git.latest:
#   - {rev: master }
#   - {fetch_tags: False }
#   - {target: "/usr/lib/rabbitmq-management" }
#   - {name: "https://github.com/rabbitmq/rabbitmq-management.git" }

create_dir_rabbit_management:
  file.directory:
  - name: /usr/lib/rabbitmq-management/
  - user: root
  - group: root
#  - mode: 755
  - makedirs: true

install_rabbit_management:
  cmd.run:
    - name : curl -k -L http://localhost:15672/cli/rabbitmqadmin -o /usr/lib/rabbitmq-management/rabbitmqadmin
    - require:
      - file : create_dir_rabbit_management


chmod_rabbit_management:
  file.managed:
  - name: /usr/lib/rabbitmq-management/rabbitmqadmin
  - user: root
  - group: root
  - mode: 755
  - require:
    - cmd : install_rabbit_management
