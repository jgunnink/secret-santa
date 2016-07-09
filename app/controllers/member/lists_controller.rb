class Member::ListsController < Member::BaseController

  def new
    @list = current_user.lists.build
    authorize!(:new, @list)
  end

  def create
    @list = current_user.lists.build(list_params)
    authorize!(:create, @list)
    @list.update_attributes(list_params)

    respond_with(@list, location: member_dashboard_index_path)
  end

  def edit
    @list = find_list
    authorize!(:edit, @list)
  end

  def update
    @list = find_list
    authorize!(:update, @list)
    @list.update_attributes(list_params)

    respond_with(@list, location: member_dashboard_index_path)
  end

  def destroy
    @list = find_list
    authorize!(:destroy, @list)
    @list.destroy

    respond_with(@list, location: member_dashboard_index_path, success: "List was successfully deleted")
  end

  def show
    @list = find_list
    authorize!(:show, @list)
  end

private

  def list_params
    params.require(:list).permit(:name, santas_attributes: [:id, :name, :email, :_destroy])
  end

  def find_list
    List.find(params[:id])
  end

end
