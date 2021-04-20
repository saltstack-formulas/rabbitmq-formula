# frozen_string_literal: true

control 'rabbitmq.config.file' do
  title 'Verify the configuration file'

  # describe file('/etc/rabbitmq/rabbitmq.conf') do
  #   it { should_exist }
  #   it { should be_file }
  # end
  describe file('/etc/rabbitmq/rabbitmq-env.conf') do
    it { should exist }
    it { should be_file }
    its('content') { should include 'RABBITMQ_MNESIA_BASE=/var/lib/rabbitmq' }
  end
end
