class CountriesController < ApplicationController
  
  def show
    country = CountryAdapter.new Carmen::Country.coded(params[:id])
    render json: country.decorated
  end
end
