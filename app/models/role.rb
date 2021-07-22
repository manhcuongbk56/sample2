class Role < ApplicationRecord
  has_many :permissions_roles
  has_many :permissions, through: :permissions_roles

  ROLES = {
    owner: 'OWNER',
    admin: 'ADMIN',
    user:  'USER',
    sales: 'SALES'
  }
end
