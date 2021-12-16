1. Concept of Jbuilder 
2. Generate token for Authentication and use of devise gem

**2.Generate token for Authentication and use of devise gem**
*Note: Rails version 6.1.4*
Token based authentication is an alternative to session-based authentication. In session based authentication sessions are stored in server. While in token based authentication token is stored on the client side.

Let's code

a. Create new rails app<br>
      `rails new app_name --api`<br>
   By appending --api at the end of the generator an API only application will be created (i.e no reb views, helper,assets).

b. Setup and install devise<br>
       `gem 'devise'` then    `bundle`<br>
       Setup devise in your app <br>
        `rails g devise:install`

c. Create user model <br>
        `rails g devise User` don't forget to migrate `rails db:migrate`<br>

d. jwt gem for cryptographic signing.<br>
        `gem 'jwt'` then `bundle`<br>
    *after adding gem in the Gemfile don't forget to bundle*

e. Creating session controler for login operation.<br>
        `rails g controler api/v1/sessions`<br>
    This will auto generate the file sessions_controller.rb as api/v1/sessions_controller.rb
    *v1 is used for versioning*<br>

    In sessions_controller.rb 
        `class Api::V1::SessionsController < ApplicationController
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
        
    end`
<br>

i. First find user with correct email address. 
ii. Check the password valid or not? If it is valid generate the token using jwt variable . **jwt** gem plays major role here.Token expires in every one hour.  Rails.application.secrets.secret_key_base, generate secret key.'HS256' hash agorithm for encryption.
