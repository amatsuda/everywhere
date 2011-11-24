require 'active_record'

module Everywhere
  class Railtie < ::Rails::Railtie #:nodoc:
    initializer 'everywhere' do |app|
      ActiveSupport.on_load(:active_record) do
#         require 'everywhere/symbol'
#         require 'everywhere/method'
#         require 'everywhere/hash_key'
        require 'everywhere/hash_value'
      end
    end
  end
end
