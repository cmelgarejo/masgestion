class Api::V1::LocationsController < ApiController
  before_action :set_resource, only: [:show]

  def countries
    json_response CountryStateSelect.countries_collection.map{ |pair| Hash[*pair.reverse] }
  end

  def states
    country= params[:country]
    json_response CountryStateSelect.collect_states(country).map{ |pair| Hash[*pair.reverse] }
  end

  def cities
    country = params[:country]
    state = params[:state]
    json_response CountryStateSelect.collect_cities(state, country)#.map{ |pair| Hash[*pair.reverse] }
  end

end
