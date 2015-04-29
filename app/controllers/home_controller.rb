class HomeController < ApplicationController

  def index
    respond_to do |format|
      format.html
    end
  end
  
  def robots
    @robots = BlogPost.where("category LIKE ?", '%robots%')
    respond_to do |format|
      format.html
    end
  end

  def publications
    @publications = BlogPost.where("category LIKE ?", '%publications%')
    respond_to do |format|
      format.html
    end
  end
  
end
