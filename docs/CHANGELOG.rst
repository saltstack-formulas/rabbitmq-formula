
Changelog
=========

`0.17.0 <https://github.com/saltstack-formulas/rabbitmq-formula/compare/v0.16.0...v0.17.0>`_ (2019-11-21)
-------------------------------------------------------------------------------------------------------------

Continuous Integration
^^^^^^^^^^^^^^^^^^^^^^


* **travis:** opt-in to ``dpl v2`` to complete build config validation [skip ci] (\ `ff04ee9 <https://github.com/saltstack-formulas/rabbitmq-formula/commit/ff04ee9439d4884a5ced793ee978e056064908a8>`_\ )

Features
^^^^^^^^


* **config.sls:** remove guest user by default (\ `4531ac4 <https://github.com/saltstack-formulas/rabbitmq-formula/commit/4531ac48983f9ad7da51f4d6b562754483d9baad>`_\ )

Tests
^^^^^


* **rabbitmq_users_spec.rb:** fix rubocop violations (\ `57efa45 <https://github.com/saltstack-formulas/rabbitmq-formula/commit/57efa458af19851ae030eb788f35fcf20bb157b6>`_\ )

`0.16.0 <https://github.com/saltstack-formulas/rabbitmq-formula/compare/v0.15.1...v0.16.0>`_ (2019-11-19)
-------------------------------------------------------------------------------------------------------------

Bug Fixes
^^^^^^^^^


* **latest:** ensure required Debian packages are installed (\ `89b470f <https://github.com/saltstack-formulas/rabbitmq-formula/commit/89b470f7124795353a5087ac872d1e8c510f240c>`_\ )

Continuous Integration
^^^^^^^^^^^^^^^^^^^^^^


* **kitchen+travis:** add ``latest`` suite (\ `29fbcd2 <https://github.com/saltstack-formulas/rabbitmq-formula/commit/29fbcd2f374bfd02742743587cda6bbcbe6389c7>`_\ )
* **travis:** apply changes from build config validation [skip ci] (\ `4a1dacb <https://github.com/saltstack-formulas/rabbitmq-formula/commit/4a1dacbff36199c3692336fe6ac2a29ceaae49a8>`_\ )

Features
^^^^^^^^


* **travis:** apply changes from build config validation (\ `7d9533c <https://github.com/saltstack-formulas/rabbitmq-formula/commit/7d9533c31842f36b943e033bce6b9bc794121d1d>`_\ )

`0.15.1 <https://github.com/saltstack-formulas/rabbitmq-formula/compare/v0.15.0...v0.15.1>`_ (2019-11-14)
-------------------------------------------------------------------------------------------------------------

Bug Fixes
^^^^^^^^^


* **latest.sls:** use Bintray repo on Debian (\ `b50f347 <https://github.com/saltstack-formulas/rabbitmq-formula/commit/b50f347c94d582f43d86182959a8b966e78dac0e>`_\ )
* **release.config.js:** use full commit hash in commit link [skip ci] (\ `b4b27d2 <https://github.com/saltstack-formulas/rabbitmq-formula/commit/b4b27d2479770312e5130692dfa44c003857be1d>`_\ )

Continuous Integration
^^^^^^^^^^^^^^^^^^^^^^


* **kitchen:** use ``develop`` image until ``master`` is ready (\ ``amazonlinux``\ ) [skip ci] (\ `a5a1944 <https://github.com/saltstack-formulas/rabbitmq-formula/commit/a5a194408e7f81a79b51be47feced1b883690753>`_\ )
* **travis:** use build config validation (beta) [skip ci] (\ `e0f5076 <https://github.com/saltstack-formulas/rabbitmq-formula/commit/e0f50762fa01b2ef3e0621dd4b4246d1d8d81e05>`_\ )

Performance Improvements
^^^^^^^^^^^^^^^^^^^^^^^^


* **travis:** improve ``salt-lint`` invocation [skip ci] (\ `1bf9e23 <https://github.com/saltstack-formulas/rabbitmq-formula/commit/1bf9e23f02801179b97021fe94c2d90a37d7cb04>`_\ )

`0.15.0 <https://github.com/saltstack-formulas/rabbitmq-formula/compare/v0.14.1...v0.15.0>`_ (2019-10-29)
-------------------------------------------------------------------------------------------------------------

Features
^^^^^^^^


* **semantic-release:** implement for this formula (\ ` <https://github.com/saltstack-formulas/rabbitmq-formula/commit/2b5e400>`_\ )

Tests
^^^^^


* implement test using Kitchen and Inspec, and CI with Travis (\ ` <https://github.com/saltstack-formulas/rabbitmq-formula/commit/e9eb8ff>`_\ )
