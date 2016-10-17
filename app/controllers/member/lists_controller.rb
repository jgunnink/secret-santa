class Member::ListsController < Member::BaseController

  before_filter :redirect_if_locked, only: [:lock_and_assign, :santas, :edit, :update]

  def new
    @list = current_user.lists.build
    authorize!(:new, @list)
  end

  def create
    @list = current_user.lists.build(name: params[:list][:name])
    authorize!(:create, @list)
    @list.update_attributes(list_params)

    if !@list.valid?
      flash.now[:danger] = "List could not be created. Please address the errors below."
      render :new
    else
      respond_with(@list, location: member_list_santas_path(@list))
    end
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

  def copy_list
    find_list
    authorize!(:copy, @list)
    if @list.is_locked? || Time.now > @list.gift_day
      new_list = @list.deep_clone include: :santas
      new_list.update_attributes(gift_day: Time.now + 2.months, is_locked: false)
      @list = new_list
      respond_with(@list, location: edit_member_list_path(@list))
    else
      flash[:warning] = "List is not locked, please edit it instead!"
      render :show
    end
  end

  def edit
    find_list
    authorize!(:edit, @list)
  end

  def santas
    find_list
    authorize!(:edit, @list)
  end

  def update
    find_list
    authorize!(:update, @list)
    # This prevents the list from being updated with nothing preventing an exception.
    @list.update_attributes(list_params) if params.include?(:list)

    if !@list.valid? && params[:list].include?(:santas_attributes)
      flash.now[:danger] = "Santas could not be saved! Please try again."
      render :santas
    else
      respond_with(@list, location: member_dashboard_index_path)
    end
  end

  def destroy
    find_list
    authorize!(:destroy, @list)
    @list.destroy

    respond_with(@list, location: member_dashboard_index_path, success: "List was successfully deleted.")
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

  def redirect_if_locked
    find_list
    if @list.is_locked?
      flash[:warning] = "Sorry! You can no longer modify this list!
                        The list has been locked and Santas notified."
      redirect_to member_dashboard_index_path
    end
  end

end
