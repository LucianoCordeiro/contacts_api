class ContactsController < AuthController
  before_action :logged_in?

  def find_addresses
    addresses = FindAddresses.new(
      state: params[:state],
      city: params[:city],
      address_string: params[:address_string]
    ).run


    render json: {
      addresses: addresses
    }
  rescue => e
    render json: {error: e}, status: 400
  end

  def index
    contacts = current_user.contacts
                              .with_name(params[:name])
                              .with_cpf(params[:cpf])
                              .page(params[:page] || 1)
                              .per(params[:per_page] || 50)
                              .order(name: params[:order_type] || "asc")

    render json: {
      contacts: contacts
    }
  rescue => e
    render json: {error: e}, status: 400
  end

  def create
    contact = current_user.contacts.create!(permitted_params)

    render json: {
      contact: contact
    }
  rescue => e
    render json: {error: e}, status: 400
  end

  def update
    contact.update!(permitted_params)

    render json: {
      contact: contact
    }
  rescue => e
    render json: {error: e}, status: 400
  end

  def destroy
    contact.destroy

    render json: {
      message: "Contato excluído"
    }
  rescue => e
    render json: {error: e}, status: 400
  end

  private

  def contact
    @contact ||= current_user.contacts.find(params[:id])
  end

  def permitted_params
    params.permit(
      :id, :cpf, :name, :address, :phone
    )
  end
end
