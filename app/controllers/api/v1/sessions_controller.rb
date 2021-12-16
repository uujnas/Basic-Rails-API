class Api::V1::SessionsController < ApplicationController
    def create
      @user = User.find_by(email: params[:email])
      if @user&.valid_password?(params[:password])
        jwt = JWT.encode(
            { user_id: @user.id, exp: (1.hour.from_now).to_i },
            Rails.application.secrets.secret_key_base,
            'HS256'
        )
        render json: { token: jwt, user: @user.as_json }
      end
    end
    
  end