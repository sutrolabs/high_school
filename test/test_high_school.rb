# frozen_string_literal: true

require "test_helper"
require "redis"

class TestHighSchool < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::HighSchool::VERSION
  end

  def test_threads
    redis = Redis.new
    locker = HighSchool::Locker.new(redis)

    x = 0

    10.times.map do |i|
      Thread.new do
        locker.lock("the_name_of_my_lock",
                    acquire_timeout: 10,
                    lock_timeout: 3600
                    ) do

            before = x.to_i
            puts "before (#{ i }): #{ x }"
            x += 1
            assert_equal before + 1, x
        end
      end
    end.each(&:join)

    assert_equal 10, x
  end
end
