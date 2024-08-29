FactoryBot.define do
  factory :contact do
    name { 'Janilson Costa Silva' }
    cpf { '123.456.789-00' }
    phone { '(11) 9 9999-9999' }
    street { 'Rod. Régis Bittencourt' }
    number { '1000' }
    complement { 'Bloco 1, Apto 101' }
    city_name { 'Taboão da Serra' }
    state { 'SP' }
    zipcode { '06768-200' }
  end
end