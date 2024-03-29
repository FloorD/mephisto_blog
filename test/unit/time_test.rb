require File.dirname(__FILE__) + '/../test_helper'

class TimeTest < ActiveSupport::TestCase

  def test_should_display_date_with_ordinal_day
    assert_equal "January 1st 12:00 AM", Time.local(2006, 1, 1).to_ordinalized_s(:plain)
  end

  def test_should_show_year_delta
    assert_equal [Time.local(2006, 1, 1), Time.local(2007,1,1)-1], Time.local(2006,7,1).to_delta(:year)
  end

  def test_should_show_month_delta
    assert_equal [Time.local(2006, 7, 1), Time.local(2006, 8, 1)-1], Time.local(2006, 7, 15).to_delta(:month)
    assert_equal [Time.local(2006, 11, 1), Time.local(2006, 12, 1)-1], Time.local(2006, 11, 1).to_delta(:month)
    assert_equal [Time.local(2006, 12, 1), Time.local(2007, 1, 1)-1], Time.local(2006, 12, 1).to_delta(:month)
  end

  def test_should_show_daily_delta
    assert_equal [Time.local(2006, 7, 15), Time.local(2006,7,16)-1], Time.local(2006,7,15).to_delta
  end
end
