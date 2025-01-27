class User < ApplicationRecord
    after_create :update_user_in_cache
    after_destroy :remove_user_from_cache
    has_secure_password
    validates :email, 
        presence: { message: "Email is invalid" }, 
        uniqueness: { message: "has already been taken"}, 
        format: { 
            with: /\A[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\z/, 
            message: "is invalid" 
        }

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
