class User < ApplicationRecord
    after_create :update_user_in_cache
    after_destroy :remove_user_from_cache
    has_secure_password
    validates :email, presence: true, uniqueness: true

    def self.get_cached_users
        Rails.cache.fetch("users", expires_in: 12.hours) do
            User.all.to_a
        end
    end

    private

    def update_user_in_cache
        users = Rails.cache.fetch("users") { User.all.to_a }
        users << self
        Rails.cache.write("users", users,expires_in: 12.hours)  
    end

    def remove_user_from_cache
        users = Rails.cache.fetch("users") { User.all.to_a }
        users.delete(self)
        Rails.cache.write("users", users,expires_in: 12.hours)  
    end
end
