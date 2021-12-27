class PublicController < ApplicationController
    def index
        @city = request.location.city
        @country = request.location.country
        # @currency = request.currency
    end

end
