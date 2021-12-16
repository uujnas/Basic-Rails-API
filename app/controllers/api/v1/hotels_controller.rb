class Api::V1::HotelsController < ApplicationController

    def index 
        @hotels = current_user.hotels.all 
        render json: @hotels
    end

end
