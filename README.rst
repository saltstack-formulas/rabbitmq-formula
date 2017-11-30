================
rabbitmq-formula
================

This formula installs and configures the RabbitMQ server.

Available states
================

.. contents::

``rabbitmq``
------------

Install rabbitmq-server and make sure that service is running.

``rabbitmq.config``
-------------------

Configure rabbitmq server via pillar. See pillar.example.

``rabbitmq.latest``
-------------------

Install latest rabbitmq from vendor repositories instead of version bundled with distribution. Use instead of rabbitmq state.

``rabbitmq.uninstall``
-------------------

Uninstall an existing RabbitMQ installation. This state wipes the machine from everything related to RabbitMQ: package, binaries, log files, configuration files. Dependencies installed in the OS with the RabbitMQ packages are *not* removed.