# frozen_string_literal: true

package_name = 'rabbitmq-server'

control 'rabbitmq package' do
  title 'should be installed'

  describe package(package_name) do
    it { should be_installed }
  end
end
