FactoryBot.define do
  factory :visit do
    data { "2022-02-19" }
    status { "MyString" }
    checkin_at { "2022-02-19 07:15:34" }
    checkout_at { "2022-02-19 07:15:34" }
    user { nil }
  end
end
