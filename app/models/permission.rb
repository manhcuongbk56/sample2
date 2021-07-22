class Permission < ApplicationRecord
  has_many :permissions_roles
  has_many :roles, through: :permissions_roles

  PERMISSIONS = {
    all:    'ALL',
    create: 'CREATE',
    read:   'READ',
    update: 'UPDATE',
    delete: 'DELETE'
  }
end
