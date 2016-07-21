class Member::ListsController < Member::BaseController

  before_filter :check_if_gift_day_has_passed, only: [:edit, :update, :destroy]

  def new
    @list = current_user.lists.build
    authorize!(:new, @list)
  end

  def create
    @list = current_user.lists.build(name: params[:list][:name])
    authorize!(:create, @list)
    @list.update_attributes(list_params)

    respond_with(@list, location: member_dashboard_index_path)
  end

  def edit
    find_list
    authorize!(:edit, @list)
  end

  def update
    find_list
    authorize!(:update, @list)
    @list.update_attributes(list_params)

    respond_with(@list, location: member_dashboard_index_path)
  end

  def destroy
    find_list
    authorize!(:destroy, @list)
    @list.destroy

    respond_with(@list, location: member_dashboard_index_path, success: "List was successfully deleted")
  end

  def show
    find_list
    authorize!(:show, @list)
  end

private

  def list_params
    params.require(:list).permit(:name, :gift_day, santas_attributes: [:id, :name, :email, :_destroy])
  end

  def find_list
    @list = List.find(params[:id])
  end

  def check_if_gift_day_has_passed
    find_list
    if Time.now > @list.gift_day
      flash[:warning] = "Sorry! As the gift day has passed, you can no longer modify or delete this list!"
      redirect_to member_dashboard_index_path
    end
  end

end
