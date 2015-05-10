class ListsController < ApplicationController
  before_action :set_list, only: [:show, :edit, :update, :destroy]
  before_action :is_owner, only: [:edit, :show]
  
  # GET /lists
  # GET /lists.json
  def index
    if user_signed_in?
      @lists = List.only_user(current_user.id).search(params[:search]).order("created_at DESC")
    else
      @lsits = nil
    end
    @new_list = List.new
    @params = params
  end

  # GET /lists/1
  # GET /lists/1.json
  def show
  end

  # GET /lists/new
  def new
    @list = List.new
  end

  # GET /lists/1/edit
  def edit
  end

  # POST /lists
  # POST /lists.json
  def create
    @list = List.new(list_params)
    @list.user_id = current_user.try(:id)
    respond_to do |format|
      if @list.save
        format.html { redirect_to @list, notice: 'List was successfully created.' }
        format.json { render action: 'show', status: :created, location: @list }
      else
        flash[:danger] = @list.errors.full_messages
        format.html { redirect_to lists_path }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lists/1
  # PATCH/PUT /lists/1.json
  def update
    respond_to do |format|
      if @list.update(list_params)
        format.html { redirect_to @list, notice: 'List was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lists/1
  # DELETE /lists/1.json
  def destroy
    @list.destroy
    respond_to do |format|
      format.html { redirect_to lists_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_list
      @list = List.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def list_params
      params.require(:list).permit(:user_id, :title, :body, :completeness)
    end
    
    def is_owner
      unless current_user.try(:id) == List.find(params[:id]).user_id
        redirect_to '/'
      end
    end
    
end
