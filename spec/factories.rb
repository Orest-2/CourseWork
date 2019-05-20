FactoryBot.define do

    factory :user do
      email {"test@gmail.com"}
      password {"pass_123"}
      is_admin  {false}
      is_executor  {false}
      is_secretary {false}
    end

    factory :user_param do
      first_name {"fname"}
      last_name {"lname"}
      email {"test@gmail.com"}
      address {"Ungvar s. Radvanka 5"}
    end
  
  end