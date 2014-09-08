ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def assert_equals_with_expect(left, right)
    assert left == right, expect_got(right, left)
  end

  def expect_got(expected, got)
    "expected '" + expected.to_s + "' - got '" + got.to_s + "'"
  end
end
