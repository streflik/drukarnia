require 'test_helper'

class PrinttypeTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Printtype.new.valid?
  end
end
