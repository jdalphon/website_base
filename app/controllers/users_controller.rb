require 'gravatar'
class UsersController < ApplicationController
  before_filter :authenticate_user!
  def show
    @user = User.find(params[:id])
    @gravatar_url = Gravatar.new.url(@user)
    respond_to do |format|
      format.html
    end
  end
end