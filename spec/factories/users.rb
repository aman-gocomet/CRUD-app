FactoryBot.define do
    factory :user do
      sequence(:email) { |n| "user#{n}@example.com" }
      sequence(:name) { |n| "User#{n}" }
      password { "Password" }
      password_confirmation { "Password" }
    end
  end
  