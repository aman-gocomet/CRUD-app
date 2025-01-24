class Api::User::RegistrationController < ApplicationController
  def get_all
    users = User.get_cached_users
    render json: users.map {|user| {email:user.email,name:user.name}}, status: :ok
  end

  def create
    user = User.new(user_params)
    if user.save
      saved_user = {email: user.email, name: user.name}
      render json: { message: 'User created successfully', user: saved_user }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def delete 
    user = User.find_by(email: params[:email])
    if user
      user.destroy
      render json: { message: 'User deleted successfully' }, status: :ok
    else
      render json: { message: 'User not found' }, status: :not_found
    end
  end

  def update
    user = User.find_by(email: params[:email])
    if user
      user.update(user_params)
      render json: { message: 'User updated successfully' }, status: :ok
    else
      render json: { message: 'User not found' }, status: :not_found
    end
  end

  private

  def user_params
    params.permit(:email, :name, :password, :password_confirmation)
  end
end
