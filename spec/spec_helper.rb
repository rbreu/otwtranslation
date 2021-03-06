# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../test_app/config/environment", __FILE__)
require File.expand_path('../../features/support/factories.rb', __FILE__)

require 'rspec/rails'
require 'authlogic/test_case'


# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(File.expand_path("../../", __FILE__ ), "spec", "support", "**", "*.rb")].each {|f| require f}

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  config.include Authlogic::TestCase, :type => :controller

  config.before(:each) do
    $redis.flushall
    Rails.cache.clear
  end

end



# For use within controllers:

def admin_login()
  activate_authlogic
  user = Factory(:translation_admin)
  UserSession.create user
end


