# High School - a Redis mutex in Ruby and Lua

I had my backpack stolen in high school while I was distracted playing chess. :(

Lesson learned. Keep your stuff safe in your locker.

My loss to high school bullies => your win! :)

Here's a simple Redis based Locker for your stuff.

(Implements the [locking strategy](https://redislabs.com/ebook/part-2-core-concepts/chapter-6-application-components-in-redis/6-2-distributed-locking/6-2-5-locks-with-timeouts/) from Redis Labs' book about... Redis)

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add high_school

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install high_school

## Usage

```ruby
@locker = HighSchool::Locker.new(my_redis_instance)

@locker.lock(
    "the_name_of_my_lock",
    acquire_timeout: 10.seconds,
    lock_timeout: 1.hour
    ) do

    # keep this code safe from other threads trampling on.
end
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

Feedback
--------
[Source code available on Github](https://github.com/sutrolabs/high_school). Feedback and pull requests are greatly appreciated. Let us know if we can improve this.

From
-----------
:wave: The folks at [Census](http://getcensus.com) originally put this together. Have data? We'll sync your data warehouse with your CRM and the customer success apps critical to your team.