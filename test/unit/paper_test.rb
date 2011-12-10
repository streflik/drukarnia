require 'test_helper'

class PaperTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Paper.new.valid?
  end
end
