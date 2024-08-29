class Contact < ApplicationRecord
  belongs_to :account

  validates :name, :cpf, :phone, :street, :city_name, :state, :zipcode, presence: true
  validates :cpf, uniqueness: { scope: :account_id }
  validates_cpf_format_of :cpf
  validates :phone, phone: true

  before_validation :sanitize_data

  def full_address
    "#{street}, #{number} - #{city_name} - #{state}"
  end

  def cpf_formatted
    CPF.new(cpf).formatted
  end

  def phone_formatted
    Phonelib.parse(phone)&.local_number
  end

  private

  def sanitize_data
    self.cpf = CPF.new(cpf).stripped if cpf.present?
    self.phone = Phonelib.parse(phone)&.sanitized if phone.present?
  end
end
