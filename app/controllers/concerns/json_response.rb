module JsonResponse
  def json_response(object, status: :ok, location: nil)
    render json: object, status:, location:
  end
end
