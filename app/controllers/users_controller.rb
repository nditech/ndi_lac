class UsersController < ApplicationController
  load_and_authorize_resource
  skip_authorize_resource :only => [:profile, :update]
  
  def index
    @users = User.all
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new user_params
    generated_password = Devise.friendly_token.first(8)
    @user.set_password generated_password
    if @user.save
      UsersMailer.welcome_email(@user, generated_password).deliver
      redirect_to users_url, notice: 'User created successfully. An email with login information was sent.'
    else
      render :new, error: 'There is some errors in your user.'
    end
  end
  
  def edit
    @user = User.find params[:id]
  end
  
  def update
    @user = User.find params[:id]
    if @user.update_attributes user_params
      redirect_to users_url, notice: 'User updated successfully.'
    else
      render :edit, error: 'There is some errors in your user.'
    end
  end
  
  def destroy
    @user = User.find params[:id]
    if @user.delete
      redirect_to users_url, notice: 'User updated successfully.'
    else
      redirect_to users_url, notice: 'There is an error deleting the user.'
    end
  end
  
  def profile
    @user = current_user
    render :edit
  end
  
  private
  
  def user_params
    params.require(:user).permit(
      :email,
      :country_code,
      :pasword,
      :password_confirmation
    )
  end
  
end
