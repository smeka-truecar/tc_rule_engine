class Dealer < ApplicationRecord
  has_many :rules, dependent: :destroy
end