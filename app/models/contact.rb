class Contact < ApplicationRecord
  belongs_to :account

  validates :name, :cpf, :phone, :street, :city_name, :state, :zipcode, presence: true
  validates :cpf, uniqueness: { scope: :account_id }

  def full_address
    "#{street}, #{number} - #{city_name} - #{state}"
  end
end
