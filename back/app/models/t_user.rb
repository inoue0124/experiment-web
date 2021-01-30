class TUser < ApplicationRecord
  has_secure_password
  has_many :d_facesheets, dependent: :destroy
  has_many :d_assessments, dependent: :destroy
  has_many :d_transfers, dependent: :destroy
end
