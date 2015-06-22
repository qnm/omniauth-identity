require 'sequel'

module OmniAuth
  module Identity
    module Models
      module Sequel
        def self.included(base)
          base.class_eval do
            include OmniAuth::Identity::Model
            include OmniAuth::Identity::SecurePassword

            # has_secure_password assumes the validators are class-level and
            # named in the active record convention, so enable them here.
            plugin :validation_class_methods

            has_secure_password

            attr_accessor :password_confirmation

            alias persisted? exists?

            def self.auth_key=(key)
              super
              validates_uniqueness_of :key
            end

            def self.locate(search_hash)
              if self.columns.include?(:provider)
                search_hash[:provider] = 'identity'
              end

              first(search_hash.symbolize_keys)
            end
          end
        end
      end
    end
  end
end
