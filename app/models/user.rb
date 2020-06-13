require 'bcrypt'

class User < ApplicationRecord
  has_secure_password
  has_many :shifts, -> {order 'start asc'}

end
