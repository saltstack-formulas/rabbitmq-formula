# frozen_string_literal: true

control 'rabbitmq.package.install' do
  title 'The required package should be installed'

  package_name = 'rabbitmq-server'

  describe package(package_name) do
    it { should be_installed }
  end
end
