module Service
  extend ActiveSupport::Concern

  included do
    def self.call(**args)
      new(**args).call
    end

    def self.to_proc
      proc { |args| call(args) }
    end
  end
end
