class ContactsController < ApplicationController
  before_action :authenticate_account!
  before_action :set_contacts, only: %i[index show new create edit update]
  before_action :set_contact, only: %i[show edit update destroy confirm_destroy]

  def index
    if params[:query].present?
      result = Contact.search(account: nil, query: params[:query])

      @contacts = result if result.present?
    end
  end

  def show
    render :index
  end

  def new
    @contact = Contact.new
    render :index
  end

  def edit
    render :index
  end

  def create
    @contact = current_account.contacts.build(contact_params)

    if @contact.save
      redirect_to root_url, notice: "Contact was successfully created."
    else
      render :index, status: :unprocessable_entity
    end
  end

  def update
    if @contact.update(contact_params)
      redirect_to root_url, notice: "Contact was successfully updated."
    else
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    @contact.destroy

    redirect_to root_url, notice: "Contact was successfully destroyed."
  end

  def confirm_destroy; end

  private

    def set_contacts
      @contacts = current_account.contacts.order(name: :asc)
    end

    def set_contact
      @contact = current_account.contacts.find(params[:id])
    end

    def contact_params
      params.require(:contact).permit(:name, :cpf, :phone, :street, :number, :complement, :neighborhood, :city_name, :state, :zipcode)
    end
end
