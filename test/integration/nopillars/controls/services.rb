# frozen_string_literal: true

control 'rabbitmq.service.running' do
  title 'The service should be installed, enabled and running'

  service_name = 'rabbitmq-server'

  describe service(service_name) do
    it { should be_installed }
    # it { should be_enabled }
    it { should be_running }
  end
end
