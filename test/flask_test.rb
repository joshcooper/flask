require "test_helper"

class FlaskTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Flask::VERSION
  end
end
