class ImportsController < ApplicationController
  def show
    @import = Import.find params[:id]
  end
end
