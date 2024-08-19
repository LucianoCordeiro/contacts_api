class FindAddresses
  attr_reader :state, :city, :address_string

  def initialize(params)
    @state = params[:state]
    @city = params[:city]
    @address_string = params[:address_string]
  end

  def run
    response = Faraday.get(uri)

    JSON.parse(response.body)
  end

  def uri
    URI::DEFAULT_PARSER.escape("http://viacep.com.br/ws/#{state}/#{city}/#{address_string}/json")
  end
end
