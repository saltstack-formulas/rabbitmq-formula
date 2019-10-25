# frozen_string_literal: true

service_name = 'rabbitmq-server'

control 'rabbitmq service' do
  title 'should be running and enabled'

  describe service(service_name) do
    it { should be_enabled }
    it { should be_running }
  end
end
