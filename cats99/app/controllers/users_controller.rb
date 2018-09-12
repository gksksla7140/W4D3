class UsersController < ApplicationController
  # before_action :require_login, only: [:destroy]
  # before_action :require_logout, only: [:new, :create]
  
  def index
    @user = User.all
    render :index
  end
  
  def new
    @user = User.new
    render :new
  end
  
  def create
    @user = User.new(user_params)
    
    if @user.save!
      login!(@user)
      redirect_to user_url(@user)
    else
      flash[:error]= @user.errors.full_messages
      redirect_to new_user_url
    end 
  end
  
  def show
    @user = User.find(params[:id])
    render :show
    
  end
  
  
  private
  
  def user_params
    params.require(:user).permit(:username, :password)
    
  end
end