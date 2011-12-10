require 'test_helper'

class FormatTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Format.new.valid?
  end
end
