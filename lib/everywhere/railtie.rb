require 'active_record'

module ActiveRecord
  class Base
    cattr_accessor :where_syntax, :instance_writer => false
  end
end

module Everywhere
  class Railtie < ::Rails::Railtie #:nodoc:
    initializer 'everywhere' do |app|
      ActiveSupport.on_load(:active_record) do
        require "everywhere/#{app.config.active_record.where_syntax || 'hash_value'}"
      end
    end
  end
end
