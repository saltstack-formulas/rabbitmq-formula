# frozen_string_literal: true

control 'rabbitmq users' do
  title 'should include/exclude the given users'

  describe command('rabbitmqctl list_users') do
    its('stdout') { should_not include 'user1' }
    its('stdout') { should_not include 'airflow' }
    its('stdout') { should_not include 'saltstack_mq' }
    its('stdout') { should_not include 'guest' }
  end
end
