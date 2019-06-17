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

    factory :secretary, class: User do
      email {"testing123@gmail.com"}
      password {"pass_123"}
      is_admin  {false}
      is_executor  {false}
      is_secretary {true}
      belong_to {10}
    end

    factory :admin, class: User do
      email {"admin@gmail.com"}
      password {"pass_123"}
      is_admin  {true}
      is_executor  {false}
      is_secretary {false}
    end
  
  end