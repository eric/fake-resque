module FakeResque
  module Resque
    extend self

    @forward = true

    def enqueue(klass, *args)
      if @forward
        klass.perform(*args)
      end
    end

    def block!
      @forward = false
    end

    def unblock!
      @forward = true
    end

    def redis=(redis)
      RealResque.redis = redis
    end

    # Mocking some of the Resque methods
    def queues
      []
    end

    class Job
      def self.create(queue, klass, *args)
        Resque.enqueue(klass, *args)
      end
    end
  end
end