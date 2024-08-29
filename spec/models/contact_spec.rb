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

    context 'cpf' do
      subject { build(:contact, account:, cpf:) }

      before { create(:contact, account:, cpf:) }
      let(:account) { create(:account) }
      let(:cpf) { '129.140.513-52' }

      it 'sanitize' do
        subject = create(:contact, account: account, cpf: '743.468.616-28')
        expect(subject.cpf).to eq('74346861628')
      end

      it 'formatted' do
        expect(subject.cpf_formatted).to eq('129.140.513-52')
      end

      it 'unique' do
        expect(subject).not_to be_valid
        expect(subject.errors.messages[:cpf]).to contain_exactly('has already been taken')
      end

      it 'account different' do
        subject = build(:contact, cpf:)
        expect(subject).to be_valid
      end
    end

    context 'phone' do
      subject { build(:contact, phone:) }

      let(:phone) { '(11) 99999-9999' }

      it 'sanitize' do
        subject = create(:contact, phone: '(11) 99999-9999')
        expect(subject.phone).to eq('11999999999')
      end

      it 'formatted' do
        expect(subject.phone_formatted).to eq('(11) 99999-9999')
      end

      context 'valid' do
        context 'with mask' do
          it { expect(subject).to be_valid }
        end

        context 'without mask' do
          let(:phone) { '11999999999' }

          it { expect(subject).to be_valid }
        end
      end

      context 'invalid' do
        context 'with mask' do
          let(:phone) { '(11) 9999-9999' }

          it { expect(subject).not_to be_valid }
        end

        context 'without mask' do
          let(:phone) { '119999-9999' }

          it { expect(subject).not_to be_valid }
        end
      end
    end
  end

  describe '#full_address' do
    it 'returns the full address' do
      contact = build(:contact, street: 'Rua X', number: '123', city_name: 'São Paulo', state: 'SP')

      expect(contact.full_address).to eq('Rua X, 123 - São Paulo - SP')
    end
  end
end