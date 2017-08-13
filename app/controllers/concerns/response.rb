module Response
  def json_response(object, status = :ok, **options)
    render json: object.to_json(options), status: status
  end
end