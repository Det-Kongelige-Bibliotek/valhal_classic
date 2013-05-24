# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :admin, class: User do
    sequence(:pid) { |n| "DO_NOT_USE#{n}"}
    email "admin@kb.dk"
    password "admin123"
    name "administrator"

    after(:create) do |user|
      user.stub(:admin?).and_return true
      user.stub(update_attributes: false)
    end
  end
end