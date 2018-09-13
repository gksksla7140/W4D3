class CatsController < ApplicationController
  before_action :check_owner?, only: [:edit, :update]
  
  def check_owner?
    
    redirect_to new_session_url unless logged_in?
    redirect_to new_session_url unless !Cat.find_by(user_id: current_user.id)
  end
  
  def index
    @cats = Cat.all
    render :index
  end

  def show
    @cat = Cat.find(params[:id])
    render :show
  end

  def new
    @cat = Cat.new
    render :new
  end

  def create
    @cat = Cat.new(cat_params)
    if current_user
      @cat.owner = current_user.id
  
      if @cat.save
        redirect_to cat_url(@cat)
      else
        flash.now[:errors] = @cat.errors.full_messages
        render :new
      end
    else 
      flash.now[:errors]=["You gotta own this cat"]
      render :new 
    end 
  end

  def edit
    @cat = Cat.find(params[:id])
    # debugger
    render :edit
  end

  def update
    @cat = Cat.find(params[:id])
    if @cat.update_attributes(cat_params)
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :edit
    end
  end

  private

  def cat_params
    params.require(:cat).permit(:age, :birth_date, :color, :description, :name, :sex)
  end
end
