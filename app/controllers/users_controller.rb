class UsersController < ApplicationController

 before_action :signed_in_user, only: [:index,:edit, :update]
 before_action :correct_user,   only: [:edit, :update]
 before_action :admin_user,     only: :destroy
 
  def show 
	   @user = User.friendly.find(params[:id])
     
  end

  def destroy
    User.friendly.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

  def new
    @user = User.new
  end

   def index
    @users = User.paginate(page: params[:page])
  end
  
  def create
  	@user = User.new(user_params) 

  	if @user.save
      log_in @user
  	  flash[:success] = "Welcome to the BETA of amzDAY"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.friendly.find(params[:id])
  end

  def update
    @user = User.friendly.find(params[:id])
    if @user.update_attributes(user_params)
      # Handle a successful update.
       flash[:success] = "Profile updated"
      log_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end


    

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
    
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
  
    # Before filters

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to login_url, notice: "Please sign in."
      end
    end

     def correct_user
      @user = User.friendly.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
end
