module Api
  module V1
    class AuthController < ApplicationController
      before_action :authorize_request, except: [:login]

      # POST /api/v1/auth/login
      def login
        user = User.find_by(username: params[:username])

        if user&.authenticate(params[:password])
          token = JsonWebToken.encode(user_id: user.id, role: user.role)
          render json: {
            token: token,
            user: {
              id: user.id,
              name: user.name,
              username: user.username,
              email: user.email,
              role: user.role
            }
          }, status: :ok
        else
          render json: { error: "Username atau password salah" }, status: :unauthorized
        end
      end

      # GET /api/v1/auth/me
      def me
        render json: {
          user: {
            id: @current_user.id,
            name: @current_user.name,
            username: @current_user.username,
            email: @current_user.email,
            role: @current_user.role
          }
        }, status: :ok
      end
    end
  end
end
