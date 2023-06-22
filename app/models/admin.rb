class Admin < ApplicationRecord
    has_secure_password
    has_one_attached :file
    has_many :meals

    # Email Validation
    validates :email, {
        uniqueness: true,
        presence: true
    }

    # Password Validation
    validates :name, {
        presence: true,
        length: { in: 4..20 }
    }

    
end
