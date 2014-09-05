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
