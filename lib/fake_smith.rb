require "fake_smith/version"

class FakeSmith
  def self.send_message(queue_name, payload, receiver)
    subscriptions[queue_name].call(payload, receiver)
  end

  def self.define_subscription(queue_name, &blk)
    subscriptions[queue_name] = blk
  end

  def self.get_messages(queue_name)
    messages[queue_name] ||= []
  end

  def self.add_message(queue_name, message)
    messages[queue_name] ||= []
    messages[queue_name] << message
  end

  def self.clear_all
    clear_subscriptions
    clear_messages
  end

  private

  def self.messages
    @messages ||= {}
  end

  def self.clear_messages
    @messages = {}
  end

  def self.subscriptions
    @subscriptions ||= {}
  end

  def self.clear_subscriptions
    @subscriptions = {}
  end

  class Logger
    def initialize
      @logs = {}
    end

    def log(level)
      @logs[level] ||= []
    end

    [:verbose, :debug, :info, :warn, :error, :fatal].each do |level|
      define_method(level = nil) do |data, &blk|
        if block_given?
          log(level) << yield
        else
          log(level) << data
        end
      end
    end
  end
end

module Smith
  module Messaging
    class Receiver
      def initialize(queue_name, options = {})
        @queue_name = queue_name
        @options = options
      end

      def subscribe(&blk)
        FakeSmith.define_subscription(@queue_name, &blk)
      end
    end
  end
end

module Smith
  module Messaging
    class Sender
      def initialize(queue_name)
        @queue_name = queue_name
      end

      def publish(message, &blk)
        FakeSmith.add_message(@queue_name, message)
      end
    end
  end
end


module Smith
  class Agent

    def self.options(opts)
    end

    def run_signal_handlers(sig, handlers)
    end

    def setup_control_queue
    end

    def setup_stats_queue
    end

    def receiver(queue_name, opts={}, &blk)
      Smith::Messaging::Receiver.new(queue_name, opts, &blk)
    end

    def sender(queue_name, opts={}, &blk)
      s = Smith::Messaging::Sender.new(queue_name)
      blk.call(s)
    end

    def acknowledge_start(&blk)
      blk.call
    end

    def acknowledge_stop(&blk)
      blk.call
    end

    def start_keep_alive
    end

    def queues
    end

    def logger
      @b06b2bd ||= FakeSmith::Logger.new
    end

    def get_test_logger
      logger
    end
  end
end
