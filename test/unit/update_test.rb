require 'test_helper'

class UpdateTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Update.new.valid?
  end
end
