class AddressesController < AuthController
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
end
