# Changelog

# [0.18.0](https://github.com/saltstack-formulas/rabbitmq-formula/compare/v0.17.0...v0.18.0) (2019-12-19)


### Continuous Integration

* **gemfile:** restrict `train` gem version until upstream fix [skip ci] ([e97c976](https://github.com/saltstack-formulas/rabbitmq-formula/commit/e97c976c4b3f3c38ff05886787289ca191912e73))
* **travis:** quote pathspecs used with `git ls-files` [skip ci] ([b350c17](https://github.com/saltstack-formulas/rabbitmq-formula/commit/b350c1704af7d624b2b975552a6ff01bac6b3aac))
* **travis:** run `shellcheck` during lint job [skip ci] ([b50083a](https://github.com/saltstack-formulas/rabbitmq-formula/commit/b50083a1f0b9489fade69da6027e00767ebd5225))


### Features

* config_files source can be a salt:// path ([69308a0](https://github.com/saltstack-formulas/rabbitmq-formula/commit/69308a071089e75d26915c0cd7e9e7aef7a9976a))


### Tests

* add test for config_files ([2854d1b](https://github.com/saltstack-formulas/rabbitmq-formula/commit/2854d1bc112349f7344c153430c0c401e8654344))

# [0.17.0](https://github.com/saltstack-formulas/rabbitmq-formula/compare/v0.16.0...v0.17.0) (2019-11-21)


### Continuous Integration

* **travis:** opt-in to `dpl v2` to complete build config validation [skip ci] ([ff04ee9](https://github.com/saltstack-formulas/rabbitmq-formula/commit/ff04ee9439d4884a5ced793ee978e056064908a8))


### Features

* **config.sls:** remove guest user by default ([4531ac4](https://github.com/saltstack-formulas/rabbitmq-formula/commit/4531ac48983f9ad7da51f4d6b562754483d9baad))


### Tests

* **rabbitmq_users_spec.rb:** fix rubocop violations ([57efa45](https://github.com/saltstack-formulas/rabbitmq-formula/commit/57efa458af19851ae030eb788f35fcf20bb157b6))

# [0.16.0](https://github.com/saltstack-formulas/rabbitmq-formula/compare/v0.15.1...v0.16.0) (2019-11-19)


### Bug Fixes

* **latest:** ensure required Debian packages are installed ([89b470f](https://github.com/saltstack-formulas/rabbitmq-formula/commit/89b470f7124795353a5087ac872d1e8c510f240c))


### Continuous Integration

* **kitchen+travis:** add `latest` suite ([29fbcd2](https://github.com/saltstack-formulas/rabbitmq-formula/commit/29fbcd2f374bfd02742743587cda6bbcbe6389c7))
* **travis:** apply changes from build config validation [skip ci] ([4a1dacb](https://github.com/saltstack-formulas/rabbitmq-formula/commit/4a1dacbff36199c3692336fe6ac2a29ceaae49a8))


### Features

* **travis:** apply changes from build config validation ([7d9533c](https://github.com/saltstack-formulas/rabbitmq-formula/commit/7d9533c31842f36b943e033bce6b9bc794121d1d))

## [0.15.1](https://github.com/saltstack-formulas/rabbitmq-formula/compare/v0.15.0...v0.15.1) (2019-11-14)


### Bug Fixes

* **latest.sls:** use Bintray repo on Debian ([b50f347](https://github.com/saltstack-formulas/rabbitmq-formula/commit/b50f347c94d582f43d86182959a8b966e78dac0e))
* **release.config.js:** use full commit hash in commit link [skip ci] ([b4b27d2](https://github.com/saltstack-formulas/rabbitmq-formula/commit/b4b27d2479770312e5130692dfa44c003857be1d))


### Continuous Integration

* **kitchen:** use `develop` image until `master` is ready (`amazonlinux`) [skip ci] ([a5a1944](https://github.com/saltstack-formulas/rabbitmq-formula/commit/a5a194408e7f81a79b51be47feced1b883690753))
* **travis:** use build config validation (beta) [skip ci] ([e0f5076](https://github.com/saltstack-formulas/rabbitmq-formula/commit/e0f50762fa01b2ef3e0621dd4b4246d1d8d81e05))


### Performance Improvements

* **travis:** improve `salt-lint` invocation [skip ci] ([1bf9e23](https://github.com/saltstack-formulas/rabbitmq-formula/commit/1bf9e23f02801179b97021fe94c2d90a37d7cb04))

# [0.15.0](https://github.com/saltstack-formulas/rabbitmq-formula/compare/v0.14.1...v0.15.0) (2019-10-29)


### Features

* **semantic-release:** implement for this formula ([](https://github.com/saltstack-formulas/rabbitmq-formula/commit/2b5e400))


### Tests

* implement test using Kitchen and Inspec, and CI with Travis ([](https://github.com/saltstack-formulas/rabbitmq-formula/commit/e9eb8ff))
