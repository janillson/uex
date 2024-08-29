FactoryBot.define do
  factory :contact do
    account { association :account }
    name { 'Janilson Costa Silva' }
    cpf { CPF.generate }
    phone { '(11) 99999-9999' }
    street { 'Rod. Régis Bittencourt' }
    number { '1000' }
    complement { 'Bloco 1, Apto 101' }
    city_name { 'Taboão da Serra' }
    state { 'SP' }
    zipcode { '06768-200' }
  end
end