FactoryBot.define do
  factory :user do
    name { "MyString" }
    username { "MyString" }
    email { "MyString" }
    password_digest { "MyString" }
    role { 1 }
    active { false }
  end
end
