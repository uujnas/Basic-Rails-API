class Api::V1::ApiController < ApplicationController
    before_action :user_token_authentication

    private 

    def current_user 
        header_token = request.header[:HTTP_AUTHORIZATION]
        if header_token 
            token = header_token.split('').last 
            begin
                decoded = JWT.decode token, Rails.application.secret_key_base,true,{algorithm: 'HS256'}
                    user = User.find(decode.first["user_id"])
                    user
                
            rescue JWT::ExpiredSignaure
                render json: {error: 'Token has been expired'}
            end
            else
                nil 
            end
        end

    def user_token_authentication 
        unless current_user 
            render json: {error: 'Invalid token found'}
        end
    end
end
   
