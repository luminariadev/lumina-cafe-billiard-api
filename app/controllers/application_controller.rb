class ApplicationController < ActionController::API
  before_action :authorize_request

  private

  def authorize_request
    header = request.headers["Authorization"]
    token = header&.split(" ")&.last

    if token
      begin
        decoded = JsonWebToken.decode(token)
        @current_user = User.find(decoded[:user_id])
      rescue JWT::DecodeError => e
        render json: { error: e.message }, status: :unauthorized
      rescue ActiveRecord::RecordNotFound
        render json: { error: "User tidak ditemukan" }, status: :unauthorized
      end
    else
      render json: { error: "Token tidak tersedia" }, status: :unauthorized
    end
  end

  def authorize_admin
    render json: { error: "Akses ditolak" }, status: :forbidden unless @current_user&.admin?
  end

  def authorize_kasir_billiard
    render json: { error: "Akses ditolak" }, status: :forbidden unless @current_user&.admin? || @current_user&.kasir_billiard?
  end

  def authorize_kasir_cafe
    render json: { error: "Akses ditolak" }, status: :forbidden unless @current_user&.admin? || @current_user&.kasir_cafe?
  end
end
