module FactoryBot
  module Strategy
    class Cache
      def association(runner)
        runner.run(:cache)
      end

      def result(evaluation)
        repository.read(evaluation) || repository.store(evaluation)
      end

      def to_sym
        :cache
      end

      protected

      def repository
        Repository.instance
      end
    end

    class Repository
      include Singleton

      def initialize
        recycle!
      end

      def recycle!
        @repository = Hash.new { |hash, key| hash[key] = {} }
      end

      def read(evaluation)
        repository[evaluation.object.class][evaluation.object.attributes]
      end

      def store(evaluation)
        repository[evaluation.object.class][evaluation.object.attributes] = evaluation.object.tap do |object|
          evaluation.notify(:after_build, object)
          evaluation.notify(:before_create, object)

          evaluation.create(object)
          evaluation.notify(:after_create, object)
        end
      end

      protected

      attr_reader :repository
    end
  end
end

FactoryBot.register_strategy(:cache, FactoryBot::Strategy::Cache)

RSpec.configure do |config|
  config.after { FactoryBot::Strategy::Repository.instance.recycle! }
  config.include FactoryBot::Syntax::Methods
end
