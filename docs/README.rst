.. _readme:

rabbitmq-formula
================

|img_travis| |img_sr| |img_pc|

.. |img_travis| image:: https://travis-ci.com/saltstack-formulas/rabbitmq-formula.svg?branch=master
   :alt: Travis CI Build Status
   :scale: 100%
   :target: https://travis-ci.com/saltstack-formulas/rabbitmq-formula
.. |img_sr| image:: https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg
   :alt: Semantic Release
   :scale: 100%
   :target: https://github.com/semantic-release/semantic-release
.. |img_pc| image:: https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white
   :alt: pre-commit
   :scale: 100%
   :target: https://github.com/pre-commit/pre-commit

This formula installs and configures RabbitMQ server on GNU/Linux.

.. contents:: **Table of Contents**
   :depth: 1

General notes
-------------

See the full `SaltStack Formulas installation and usage instructions
<https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

If you are interested in writing or contributing to formulas, please pay attention to the `Writing Formula Section
<https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html#writing-formulas>`_.

If you want to use this formula, please pay attention to the ``FORMULA`` file and/or ``git tag``,
which contains the currently released version. This formula is versioned according to `Semantic Versioning <http://semver.org/>`_.

See `Formula Versioning Section <https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html#versioning>`_ for more details.

If you need (non-default) configuration, please refer to:

- `how to configure the formula with map.jinja <map.jinja.rst>`_
- the ``pillar.example`` file
- the `Special notes`_ section

Contributing to this repo
-------------------------

Commit messages
^^^^^^^^^^^^^^^

**Commit message formatting is significant!!**

Please see `How to contribute <https://github.com/saltstack-formulas/.github/blob/master/CONTRIBUTING.rst>`_ for more details.

pre-commit
^^^^^^^^^^

`pre-commit <https://pre-commit.com/>`_ is configured for this formula, which you may optionally use to ease the steps involved in submitting your changes.
First install  the ``pre-commit`` package manager using the appropriate `method <https://pre-commit.com/#installation>`_, then run ``bin/install-hooks`` and
now ``pre-commit`` will run automatically on each ``git commit``. ::

  $ bin/install-hooks
  pre-commit installed at .git/hooks/pre-commit
  pre-commit installed at .git/hooks/commit-msg

Special notes
-------------

none

Available states
----------------

.. contents::
   :local:

``rabbitmq``
^^^^^^^^^^^^

*Meta-state (This is a state that includes other states)*.

This installs the rabbitmq package,
manages the rabbitmq configuration file and then
starts the associated rabbitmq service.

``rabbitmq.package``
^^^^^^^^^^^^^^^^^^^^

This state will install the rabbitmq package and has a dependency on ``rabbitmq.install``
via include list.

``rabbitmq.rabbitmqadmin``
^^^^^^^^^^^^^^^^^^^^^^^^^^

This state will install the rabbitmqadmin package only.

``rabbitmq.config``
^^^^^^^^^^^^^^^^^^^

This state will configure the rabbitmq service and has a dependency on ``rabbitmq.install``
via include list.

``rabbitmq.service.cluster``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

For initial setup this state writes the erlang cookie, joins cluster, and restarts service. The erlang cookie comes from pillar data and must the identical for all cluster members. Join fails if cluster is inconsistent (see rabbitmqctl forget_cluster_node rabbit@somehost).

``rabbitmq.service``
^^^^^^^^^^^^^^^^^^^^

This state will start the rabbitmq service and has a dependency on ``rabbitmq.config``
via include list.

``rabbitmq.clean``
^^^^^^^^^^^^^^^^^^

*Meta-state (This is a state that includes other states)*.

this state will undo everything performed in the ``rabbitmq`` meta-state in reverse order, i.e.
stops the service,
removes the configuration file and
then uninstalls the package.

``rabbitmq.service.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^

This state will stop the rabbitmq service and disable it at boot time.

``rabbitmq.rabbitmqadmin.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This state will remote the rabbitmqadmin package only.

``rabbitmq.config.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^

This state will remove the configuration of the rabbitmq service and has a
dependency on ``rabbitmq.service.clean`` via include list.

``rabbitmq.package.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^

This state will remove the rabbitmq package and has a depency on
``rabbitmq.config.clean`` via include list.

*Meta-state (This is a state that includes other states)*.

Testing
-------

Linux testing is done with ``kitchen-salt``.

Requirements
^^^^^^^^^^^^

* Ruby
* Docker

.. code-block:: bash

   $ gem install bundler
   $ bundle install
   $ bin/kitchen test [platform]

Where ``[platform]`` is the platform name defined in ``kitchen.yml``,
e.g. ``debian-9-2019-2-py3``.

``bin/kitchen converge``
^^^^^^^^^^^^^^^^^^^^^^^^

Creates the docker instance and runs the ``rabbitmq`` main state, ready for testing.

``bin/kitchen verify``
^^^^^^^^^^^^^^^^^^^^^^

Runs the ``inspec`` tests on the actual instance.

``bin/kitchen destroy``
^^^^^^^^^^^^^^^^^^^^^^^

Removes the docker instance.

``bin/kitchen test``
^^^^^^^^^^^^^^^^^^^^

Runs all of the stages above in one go: i.e. ``destroy`` + ``converge`` + ``verify`` + ``destroy``.

``bin/kitchen login``
^^^^^^^^^^^^^^^^^^^^^

Gives you SSH access to the instance for manual testing.
