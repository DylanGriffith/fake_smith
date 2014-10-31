# FakeSmith

FakeSmith is here to help you unit test your Smith Agents.

Have you ever wanted to test your agents without having to worry about all the overhead of running the agency and sending messages and waiting asynchronously for the magic to happen? Well want no longer and do now!

FakeSmith is a gem that you can require and it will stub out all the stuff Smith does when you try to run agents, send messages and subscribe to queues.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fake_smith'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fake_smith

## Usage

In your spec_helper or in your spec simply:

```ruby
require 'fake_smith'
```

This will stub out all smith methods so you are free to test your agents without even starting EventMachine (though you may need to if you agent depends on EventMachine stuff)

To start your agent:

```ruby
MySmithAgent.new.run
```

You may wish to send a message to your agent:

```ruby
my_receiver = double(:receiver, :ack => true)
expect(my_receiver).to receive(:ack)
FakeSmith.send_message("my_queue", MyAwesomeMessage.new(:id => "foo"), my_receiver)
```

Or see a message that your agent has put on a queue:

```ruby
messages = FakeSmith.get_messsages("my_other_queue")
expect(messages.count).to eq(1)
```

**NOTE** If you run into an error stating `wrong number of arguments (0 for 1)`
when trying to `new` up your agent then you probably have a
`require 'smith/agent'` in your agent. This will overwrite the fake Smith
agent and thus the stubbing won't work. You do not need these requires
so you can just remove it and it should work fine.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/fake_smith/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
