class UsersController < ApplicationController
  before_action :build_new_form, only: [:new, :create]
  before_action :find_user, only: [:edit, :update, :destroy]

  def create
    if @form.submit
      redirect_to :users, notice: "User created!"
    else
      render "new"
    end
  end

  def destroy
    @user.destroy!
    redirect_to :users, notice: "User deleted!"
  end

  protected

  def find_user
    @user = User.find(params[:id])
  end

  def build_new_form
    @form = Users::NewForm.new(params[:form])
  end
end
