# frozen_string_literal: true

control 'rabbitmq configuration' do
  title 'should match desired lines'

  describe file('/etc/rabbitmq/rabbitmq.conf') do
    it { should exist }
    it { should be_file }
    its('content') { should include '# Config file for rabbitmq' }
  end
end
