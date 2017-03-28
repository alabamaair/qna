FactoryGirl.define do
  factory :question do
    title 'Title-question'
    body 'Body-question'
    user
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
  end
end
