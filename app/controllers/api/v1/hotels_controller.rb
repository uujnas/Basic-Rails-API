class Api::V1::HotelsController < Api::V1::ApiController

    def index 
        @hotels = current_user.hotels.all 
        render json: @hotels
    end

end
