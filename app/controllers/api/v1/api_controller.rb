class Api::V1::ApiController < ActionController::API
    before_action :user_token_authentication
    # Creating authentication by using generated token

    private 

    def current_user 
        header_token = request.headers[:HTTP_AUTHORIZATION]
        if header_token 
            token = header_token.split(' ').last 
            begin
                decoded = JWT.decode token, Rails.application.secret_key_base,true,{algorithm: 'HS256'}
                    user = User.find(decoded.first["user_id"])
                    user
                
            rescue JWT::ExpiredSignature
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