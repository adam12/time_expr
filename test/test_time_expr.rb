require "minitest/autorun"
require "time_expr"

class TestTimeExpr < Minitest::Test
  def run
    Time.stub(:now, Time.new(2020, 1, 1)) do
      super
    end
  end

  def test_ago
    assert_equal Time.new(2019, 12, 28), TimeExpr::Duration::Days[4].ago
  end

  def test_from_now
    assert_equal Time.new(2020, 1, 5), TimeExpr::Duration::Days[4].from_now
  end

  def test_adding_mixed_durations
    assert_equal TimeExpr::Duration::Seconds[950400], TimeExpr::Duration::Weeks[1] + TimeExpr::Duration::Days[4]
  end

  def test_adding_to_time
    assert_equal Time.new(2020, 1, 5), Time.now + TimeExpr::Duration::Days[4]
  end

  def test_dsl_without_object
    assert_equal Time.new(2020, 1, 27), TimeExpr.build { weeks(4) - days(2) }.from_now
  end

  def test_dsl_with_object
    assert_equal Time.new(2020, 1, 27), TimeExpr.build { |t| t.weeks(4) - t.days(2) }.from_now
  end
end
