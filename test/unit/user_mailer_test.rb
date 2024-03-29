require File.dirname(__FILE__) + '/../test_helper'
require 'user_mailer'

class UserMailerTest < ActiveSupport::TestCase
  include ActionController::UrlWriter
  fixtures :users

  FIXTURES_PATH = File.dirname(__FILE__) + '/../fixtures'
  CHARSET = "utf-8"

  include ActionMailer::Quoting

  def setup
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    @expected = TMail::Mail.new
    @expected.set_content_type "text", "plain", { "charset" => CHARSET }
  end

  def test_forgot_password
    user = users(:quentin)
    response = UserMailer.deliver_forgot_password(user)
    assert_equal user.email, response.to[0]
    # TODO: make host dynamic
    assert_match /#{url_for :host => 'localhost:3000', :controller => 'account', :action => 'activate', :id => user.token}/, response.body
  end

  private
    def read_fixture(action)
      IO.readlines("#{FIXTURES_PATH}/user_notifier/#{action}")
    end

    def encode(subject)
      quoted_printable(subject, CHARSET)
    end
end
