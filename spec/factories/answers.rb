FactoryBot.define do
  factory :answer do
    content { "MyString" }
    answered_at { "2022-02-19 17:01:45" }
    formulary { nil }
    question { nil }
    visit { nil }
  end
end
