module TimeExpr
  class DSL
    def seconds(value)
      Duration::Seconds[value]
    end

    def minutes(value)
      Duration::Minutes[value]
    end

    def hours(value)
      Duration::Hours[value]
    end

    def days(value)
      Duration::Days[value]
    end

    def weeks(value)
      Duration::Weeks[value]
    end

    def years(value)
      Duration::Years[value]
    end
  end

  module Duration
    module TimeTravel
      def ago
        Time.now - to_i
      end

      def from_now
        Time.now + to_i
      end
    end

    module Coercible
      def to_int
        to_i
      end
    end

    module Adjustable
      def +(other)
        case other
        when Integer
          self.class[value + other]
        when self
          self.class[value + other.value]
        else
          Seconds[to_i + other.to_i]
        end
      end

      def -(other)
        case other
        when Integer
          self.class[value - other]
        when self
          self.class[value - other.value]
        else
          Seconds[to_i - other.to_i]
        end
      end

      def *(other)
        case other
        when Integer
          self.class[other * value]
        when self
          self.class[other.value * value]
        else
          Seconds[to_i * other.to_i]
        end
      end
    end

    module Inspectable
      def inspect
        "#{self.class}[#{value}]"
      end
    end

    module Equalable
      def ==(other)
        self.class == other.class && value == other.value
      end
    end

    class Seconds
      include TimeTravel
      include Coercible
      include Adjustable
      include Inspectable
      include Equalable

      def initialize(value)
        @value = value
      end

      attr_reader :value

      def to_i
        @value
      end

      def self.[](value)
        new(value)
      end
    end

    class Minutes
      include TimeTravel
      include Coercible
      include Adjustable
      include Inspectable
      include Equalable

      def initialize(value)
        @value = value
      end

      attr_reader :value

      def to_i
        @value * 60
      end

      def self.[](value)
        new(value)
      end
    end

    class Hours
      include TimeTravel
      include Coercible
      include Adjustable
      include Inspectable
      include Equalable

      def initialize(value)
        @value = value
      end

      attr_reader :value

      def to_i
        @value * 60 * 60
      end

      def self.[](value)
        new(value)
      end
    end

    class Days
      include TimeTravel
      include Coercible
      include Adjustable
      include Inspectable
      include Equalable

      def initialize(value)
        @value = value
      end

      attr_reader :value

      def to_i
        @value * 86400
      end

      def inspect
        "#{self.class}[#{value}]"
      end

      def self.[](value)
        new(value)
      end
    end

    class Weeks
      include TimeTravel
      include Coercible
      include Adjustable
      include Inspectable
      include Equalable

      def initialize(value)
        @value = value
      end

      attr_reader :value

      def to_i
        @value * 86400 * 7
      end

      def self.[](value)
        new(value)
      end
    end

    class Years
      include TimeTravel
      include Coercible
      include Adjustable
      include Inspectable
      include Equalable

      def initialize(value)
        @value = value
      end

      attr_reader :value

      def to_i
        @value * 86400 * 365
      end

      def self.[](value)
        new(value)
      end
    end
  end

  module T
    refine Object do
      def T(&blk)
        TimeExpr.build(&blk)
      end
    end

    def T(&blk)
      TimeExpr.build(&blk)
    end

    def self.activate
      Object.include(T)
    end
  end

  def self.build(&blk)
    if blk.arity == 1
      yield DSL.new
    else
      dsl = DSL.new
      dsl.instance_exec(&blk)
    end
  end
end

__END__
p TimeExpr::Duration::Days[4].ago
p TimeExpr::Duration::Days[4].from_now
p TimeExpr::Duration::Weeks[1] + TimeExpr::Duration::Days[4]
p (TimeExpr::Duration::Weeks[1] + TimeExpr::Duration::Days[4]).from_now
p Time.now + TimeExpr::Duration::Days[4]

p TimeExpr() { |t| t.weeks(4) - t.days(2) }.from_now
p TimeExpr(){ weeks(4) - days(2) }.from_now

current_time = Time.now + 87400
p TimeExpr() { current_time + weeks(4) }
p TimeExpr() { Time.now + days(4) }
p TimeExpr::Duration::Days[4] * 4

p TimeExpr::Duration::Hours[4] - 2

Time::Duration::Days[4].ago
Time::Duration::Days[4].from_now
Time::Duration::Weeks[1] + Time::Duration::Days[4]

Time::Duration { |t| t.weeks(4) - t.days(2) }

Time::Duration { Time.now + minutes(15) }
Time::Duration { Time.now + years(10) }
Time::Duration { Time.now - days(30) }
Time::Duration { }

Time::Duration { |t| t.now - t.years(years) }
