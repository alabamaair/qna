FactoryGirl.define do
  factory :comment do
    user
    body "Body-comment"
    association :commentable, factory: :question
  end

  factory :invalid_comment, class: 'Comment' do
    body nil
  end
end
