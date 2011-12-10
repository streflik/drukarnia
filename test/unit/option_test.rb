require 'test_helper'

class OptionTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Option.new.valid?
  end
end
