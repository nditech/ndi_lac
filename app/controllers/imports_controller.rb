class ImportsController < ApplicationController

  def index
    @imports = current_user.imports.order('id desc')
  end

  def show
    @import = Import.find params[:id]
  end
end
