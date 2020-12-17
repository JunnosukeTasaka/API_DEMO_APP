# frozen_string_literal: true

FactoryBot.define do
  factory :idea do
    association :category
    sequence(:body) { |n| "text_#{n}" }
  end
end
