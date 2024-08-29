require 'rails_helper'

RSpec.describe Contact do
  describe 'validations' do
    specify(:aggregate_failures) do
      expect(subject).to belong_to(:account)
      expect(subject).to validate_presence_of(:name)
      expect(subject).to validate_presence_of(:cpf)
      expect(subject).to validate_presence_of(:phone)
      expect(subject).to validate_presence_of(:street)
      expect(subject).to validate_presence_of(:city_name)
      expect(subject).to validate_presence_of(:state)
      expect(subject).to validate_presence_of(:zipcode)
    end
  end

  describe '#full_address' do
    it 'returns the full address' do
      contact = build(:contact, street: 'Rua X', number: '123', city_name: 'São Paulo', state: 'SP')

      expect(contact.full_address).to eq('Rua X, 123 - São Paulo - SP')
    end
  end
end