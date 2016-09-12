class Member::ListsController < Member::BaseController

  before_filter :check_if_gift_day_has_passed_or_locked, only: [:lock_and_assign, :edit, :update, :destroy]

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

  def lock_and_assign
    find_list
    authorize!(:update, @list)
    if @list.santas.count >= 3
      List::ShuffleAndAssignSantas.new(@list).assign_and_email
      flash.now[:success] = 'Recipients set and Santas notified'
    else
      flash.now[:danger] = 'You must have at least three Santas in the list first!'
    end
    render :show
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

    respond_with(@list, location: member_dashboard_index_path, success: 'List was successfully deleted')
  end

  def show
    find_list
    authorize!(:show, @list)
  end

private

  def list_params
    params.require(:list)
          .permit(:name,
                  :gift_day,
                  :gift_value,
                  santas_attributes: [:id, :name, :email, :_destroy]
                 )
  end

  def find_list
    if params.include?("list_id")
      @list = List.find(params[:list_id])
    else
      @list = List.find(params[:id])
    end
  end

  def check_if_gift_day_has_passed_or_locked
    find_list
    if Time.current > @list.gift_day || @list.is_locked
      flash[:warning] =
        'Sorry! You can no longer modify or delete this list!
        Either the list is locked or the gift day has passed.'
      redirect_to member_dashboard_index_path
    end
  end

end
