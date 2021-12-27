class PublicController < ApplicationController
    def index
        @city = request.location.city
        @country = request.location.country_code
        @currency = @country.upcase == "AU" ? "AUD" : "USD"
    end

end
