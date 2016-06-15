class Member::ListsController < Member::BaseController

  def index
    authorize!(:show, :list)
  end

  def new
    authorize!(:new, :list)
    @list = List.new
  end

  def create
    @list = List.new(list_params)
    authorize!(:create, :list)
    @list.update_attributes(list_params)

    respond_with(@list, location: member_list_path(@list))
  end

private

  def list_params
    params.permit(:name, :user)
  end

end


# redirect_to @scorecard, notice: 'Scorecard was successfully created.'
# else
# flash.now[:alert] = "Your scorecard could not be updated."
# render :new
# end
