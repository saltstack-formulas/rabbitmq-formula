# frozen_string_literal: true

service_name = 'rabbitmq-server'

control 'rabbitmq users' do
  describe command('rabbitmqctl list_users') do
    its('stdout') { should match (/user1/) }
    its('stdout') { should match (/user2/) }
    its('stdout') { should_not match (/guest/) }
  end
end
