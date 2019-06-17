class UserParam < ApplicationRecord
  belongs_to :user, :foreign_key => "user_id"
end
