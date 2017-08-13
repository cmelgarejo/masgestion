class Api::V1::CompaniesController < ApiController
  before_action :set_resource, only: [:show]

  def index
    json_response Company.all
  end

  def show
    json_response @resource
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_resource
    @resource = Company.find(params[:id])
  end
end
