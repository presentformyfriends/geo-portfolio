class PublicController < ApplicationController

  def index
    require 'dotenv/load'

    @theme = session[:theme]
    
    if params[:random] != "true"

      # Use Geocoder gem to look up user IP address
      @ip_address = lookup_ip_location.ip

      check_ip_address

    else

      location_hash = [
        {city: 'Bangkok', country: 'Thailand'},
        {city: 'Beijing', country: 'China'},
        {city: 'Birkirkara', country: 'Malta'},
        {city: 'Bucharest', country: 'Romania'},
        {city: 'Budapest', country: 'Hungary'},
        {city: 'Buenos Aires', country: 'Argentina'},
        {city: 'Cairo', country: 'Egypt'},
        {city: 'Campinas', country: 'Brazil'},
        {city: 'Cape Town', country: 'South Africa'},
        {city: 'Dubai', country: 'UAE'},
        {city: 'Frankfurt', country: 'Germany'},
        {city: 'Gaya', country: 'India'},
        {city: 'Geneva', country: 'Switzerland'},
        {city: 'Helsinki', country: 'Finland'},
        {city: 'Höfn', country: 'Iceland'},
        {city: 'Hyderabad', country: 'India'},
        {city: 'Istanbul', country: 'Turkey'}, 
        {city: 'Jakarta', country: 'Indonesia'},
        {city: 'Karachi', country: 'Pakistan'},
        {city: 'Kyushu', country: 'Japan'},
        {city: 'Košice', country: 'Slovakia'},
        {city: 'Lisbon', country: 'Portugal'},
        {city: 'Ely', country: 'England'},
        {city: 'Melbourne', country: 'Australia'},
        {city: 'Moscow', country: 'Russia'},
        {city: 'Nadi', country: 'Fiji'},
        {city: 'New York', country: 'USA'},
        {city: 'Novi Sad', country: 'Serbia'},
        {city: 'Oslo', country: 'Norway'},    
        {city: 'Paris', country: 'France'},
        {city: 'Patras', country: 'Greece'},
        {city: 'Prague', country: 'Czech Republic'},
        {city: 'Puebla', country: 'Mexico'},
        {city: 'Queenstown', country: 'New Zealand'},
        {city: 'Quezon City', country: 'Philippines'},
        {city: 'Santiago', country: 'Chile'},
        {city: 'Seattle', country: 'USA'},
        {city: 'Seoul', country: 'Korea'},
        {city: 'Seville', country: 'Spain'},
        {city: 'Singapore', country: 'Singapore'},
        {city: 'Stockholm', country: 'Sweden'},
        {city: 'Tel Aviv', country: 'Israel'},
        {city: 'Trieste', country: 'Italy'},
        {city: 'Tunis', country: 'Tunisia'},
        {city: 'Vienna', country: 'Austria'},
        {city: 'Virginia', country: 'USA'}
      ]

      random_location = location_hash.sample

      @city = random_location[:city]
      @country = random_location[:country]

      get_city

    end

  end


  private


  def check_ip_address
    require 'faker'

    # Check IP address is present, else use random public IP address from Faker gem
    (@ip_address = Faker::Internet.public_ip_v4_address) if !@ip_address.present?

    get_city_url

  end


  def get_city_url

    # Call to 'iplocate.io' API to get city name from user IP address
    response = Net::HTTP.get( URI.parse( "https://www.iplocate.io/api/lookup/#@ip_address" ) )
    @country = JSON.parse( response )["country"]
    @city = JSON.parse( response )["city"]
    time_zone = JSON.parse( response )["time_zone"]

    # Check city is not blank or nil else pull 'time_zone' from 'iplocate.io' response
    (@city = time_zone.split("/")[1]) if !@city.present?

    get_city

  end


  def get_city

    # URL encoding to mitigate special characters (i.e. Bogotá)
    @city_encoded = CGI.escape(@city)

    # URLs for Google Places API requests
    @base_uri = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input="
    @city_url = URI(@base_uri + "#{@city_encoded}&inputtype=textquery&fields=formatted_address%2Cname%2Cphoto&key=#{ENV['API_KEY']}")

    @photo_reference_url = get_reference(@city_url)

    @city_photo_url = get_photo(@photo_reference_url)

  end


  def get_reference(url)
    require "uri"
    require "net/http"

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Get.new(url)

    response = https.request(request)

    json = JSON.parse(response.body)

    @photo_reference = json["candidates"].first["photos"].first["photo_reference"]

    photo_reference_url = "https://maps.googleapis.com/maps/api/place/photo?maxheight=1600&?maxwidth=1600&photo_reference=#{@photo_reference}&key=#{ENV['API_KEY']}"

    return photo_reference_url

  end


  def get_photo(url)
    require "uri"
    require "net/http"

    res = Net::HTTP.get_response(URI(url))

    city_photo_url = res['location']

    return city_photo_url

  end

end
