FactoryGirl.define do
  factory :answer do
    body 'Body'
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
  end
end
