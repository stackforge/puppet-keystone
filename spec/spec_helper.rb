# Load libraries from openstacklib here to simulate how they live together in a real puppet run (for provider unit tests)
$LOAD_PATH.push(File.join(File.dirname(__FILE__), 'fixtures', 'modules', 'openstacklib', 'lib'))
require 'puppetlabs_spec_helper/module_spec_helper'
require 'shared_examples'
require 'webmock/rspec'
require 'puppet-openstack_spec_helper/facts'

# LP1492636 - Cohabitation of compile matcher and webmock
WebMock.disable_net_connect!(:allow => "169.254.169.254")

RSpec.configure do |c|
  c.alias_it_should_behave_like_to :it_configures, 'configures'
  c.alias_it_should_behave_like_to :it_raises, 'raises'
end

RSpec::Matchers.define :be_absent do
  match do |actual|
    actual == :absent
  end
end

at_exit { RSpec::Puppet::Coverage.report! }

def setup_provider_tests
  Puppet::Provider::Keystone.class_exec do
    def self.reset
      @public_endpoint = nil
      @tenant_hash    = nil
      @admin_token    = nil
      @keystone_file  = nil
      Puppet::Provider::Keystone.class_variable_set('@@default_domain_id', nil)
      @domain_hash = nil
      @users_name  = nil
      @projects_name = nil
    end
  end
end

Dir[File.dirname(__FILE__) + '/support/**/*.rb'].each { |f| require f }
