module Api
  class UsersController < ApiController

    def create
      user = User.new
      user.first_name = params[:user][:first_name]
      user.last_name = params[:user][:last_name]
      user.email = params[:user][:email]
      user.dob = params[:user][:dob]
      user.password = params[:user][:password]
      user.password_confirmation = params[:user][:password_confrimation]
      user.user_type = params[:user][:user_type]

      if user.user_type == "Driver"
        save_driver(user)
      else
        save_user(user)
      end
    end

    def sign_in
      user = User.find_by(email: params[:user][:email]).try(:authenticate, params[:user][:password])
      if user != false
        render :plain => user.token
      else
        render :plain => "Inavalid email and/or passowrd"
      end
    end

    private

    def user_reg_params
      params.require(:user).permit(:first_name, :last_name, :email, :dob, :password, :password_confrimation, :user_type, :car_type, :plate_number)
    end

    def save_user(user)
      if user.save!
        render :plain => "Your registration was successfully, sign in to use our service"
      else
        render :plain => "We could not create an account for you.Please try again"
      end
    end

    def save_driver(user)
      user = save_user(user)
      if User.exists?(user.id)
        driver = Driver.new(user_id: user.id, car_type: params[:user][:car_type], plate_number: params[:user][:plate_number])
        if driver.save!
          render :plain => "Your registration was successfully, sign in to use our service"
        else
          User.delete(user)
          render :plain => "Something went wrong while trying to save your car details"
        end
      else
        render :text => "We could not create an account for you.Please try again"
      end
    end

  end
end
