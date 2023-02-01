# frozen_string_literal: true

require_relative "high_school/version"
require 'securerandom'

module HighSchool
  # implements the locking strategy from Redis Labs' book about... Redis
  # https://redislabs.com/ebook/part-2-core-concepts/chapter-6-application-components-in-redis/6-2-distributed-locking/6-2-5-locks-with-timeouts/
  class Locker

    # unlock is a lua script because this call will run atomically vs having to issue 2 calls independently to delete the lock
    # script makes sure that the creator of the lock is the one deleting the lock.
    UNLOCK_LUA_SCRIPT = "if redis.call('get',KEYS[1])==ARGV[1] then redis.call('del',KEYS[1]) end"

    def initialize(redis)
      @redis = redis
    end

    class LockNotAcquired < StandardError
    end

    # A default timeout of 10 seconds is set on the lock. You probably want to set that to something safe for yourself.
    # But leaving it locked for infinity is probably not what you want.
    def lock(lock_name, acquire_timeout: nil, lock_timeout: 10, &block)
      identifier = SecureRandom.uuid

      end_time = Time.now + acquire_timeout if acquire_timeout

      # prefix it to make them easier to find in redis if we need to.
      lock_name = "lock:" + lock_name

      begin
        while end_time.nil? || Time.now < end_time
          # returns false if the lock with this name already exists
          if @redis.set(lock_name, identifier, nx: true, ex: lock_timeout)
            return yield
          else
            # just to vary up how many simulatenous threads are asking to set the lock
            sleep(rand(0.10..0.5))
          end
        end

        raise LockNotAcquired.new("Waited #{acquire_timeout} seconds to get lock for #{lock_name}")
      ensure
        @redis.eval(UNLOCK_LUA_SCRIPT, [lock_name], [identifier])
      end
    end
  end
end
