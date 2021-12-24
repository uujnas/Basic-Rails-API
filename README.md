1. Concept of Jbuilder 
2. Generate token for Authentication and use of devise gem

**2.Generate token for Authentication and use of devise gem**<br>
*Note: Rails version 6.1.4*<br>
Token based authentication is an alternative to session-based authentication. In session based authentication sessions
are stored in server. While in token based authentication token is stored on the client side.

Let's code

a. Create new rails app<br>
      `rails new app_name --api`<br>
   By appending --api at the end of the generator an API only application will be created (i.e no .erb views, helper,assets).

b. Setup and install devise<br>
       `gem 'devise'` then    `bundle`<br>
       Setup devise in your app <br>
        `rails g devise:install`

c. Create user model <br>
        `rails g devise User` don't forget to migrate `rails db:migrate`<br>

d. **Install jwt gem for cryptographic signing.**<br>
        `gem 'jwt'` then `bundle`<br>
    *after adding gem in the Gemfile don't forget to bundle*

e. **(Generating the token)**<br>
    *Encoding takes place*<br>
    Creating session controler for login operation.
        `rails g controler api/v1/sessions`<br>
    This will auto generate the file sessions_controller.rb as api/v1/sessions_controller.rb<br>
    *v1 is used for versioning* <br>
    In sessions_controller.rb 

        class Api::V1::SessionsController < Api::V1::ApiController
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
<br>

i. First find user with correct email address. <br>
ii. Check the password valid or not? If it is valid generate the token using jwt variable . <br>**jwt** gem plays major role here.Token expires in every one hour. <br> Rails.application.secrets.secret_key_base, generate secret key.'HS256' hash agorithm for encryption.<br><br>

f. **Checking the token**<br>
    *Decoding takes place*<br>
   Create a controller named api which will authenticated user in every request.
   `rails g controller api/v1/api`
   This will auto generate api_controller in api/v1 folder. We have used v1 for versioning. i.e It's v1 api.<br>

    # Creating authentication by using generated token
    `class Api::V1::ApiController < ActionController::API 
    before_action :user_token_authentication

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
    end`


g. Now we to check data after current user login.
  we are creating model hotels and checking list of hotels created through current user

  i. `rails g model Hotel name:string`
  ii. `rails g controller hotels`

  iii. in hotels_controller.rb
        `class Api::V1::HotelsController < Api::V1::ApiController

            def index 
                @hotels = current_user.hotels.all 
                render json: @hotels
            end

        end`
    iv. let's create some seeds file.
        in seeds.rb
        `   user1 = User.create(email: 'abc@gmail.com', password: 'password')
        user2 = User.create(email: 'xyz@gmail.com', password: 'password')

        hotel1 = ["sunshine","sunrise"]
        hotel1.each do |hotel|
            Hotel.create(name: hotel,user_id: user1.id)
        end`
    v. routes.rb
    `Rails.application.routes.draw do
  devise_for :users
    namespace :api do
        namespace :v1 do
        defaults format: :json do
            post :sign_in, to: 'sessions#create'
            resources :posts
            resources :hotels
        end
        end   
    end
    end`
