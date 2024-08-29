class Contact < ApplicationRecord
  belongs_to :account

  validates :name, :cpf, presence: true
  validates :cpf, uniqueness: { scope: :account_id }

  def full_address
    "#{street}, #{number} - #{city_name} - #{state}"
  end
end
