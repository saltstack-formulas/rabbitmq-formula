# frozen_string_literal: true

control 'rabbitmq repositories' do
  title 'should match desired sources'

  describe file('/etc/apt/sources.list.d/erlang.list') do
    it { should exist }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its('mode') { should cmp '0644' }
    its(:content) do
      should match(
        %r{deb https://dl.bintray.com/rabbitmq-erlang/debian buster erlang}
      )
    end
  end

  describe file('/etc/apt/sources.list.d/rabbitmq.list') do
    it { should exist }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its('mode') { should cmp '0644' }
    its(:content) do
      should match(
        %r{deb https://dl.bintray.com/rabbitmq/debian buster main}
      )
    end
  end
end
