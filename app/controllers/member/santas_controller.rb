class Member::SantasController < Member::BaseController

  def new
    @santa = Santa.new
    authorize!(:new, @santa)
  end

  def create
    @santa = Santa.new(santa_params)
    authorize!(:create, @santa)
    @santa.update_attributes(santa_params)

    respond_with(@santa, location: member_dashboard_index_path)
  end
#
#   def edit
#     @santa = find_santa
#     authorize!(:edit, @santa)
#   end
#
#   def update
#     @santa = find_santa
#     authorize!(:update, @santa)
#     @santa.update_attributes(santa_params)
#
#     respond_with(@santa, location: member_dashboard_index_path)
#   end
#
#   def destroy
#     @santa = find_santa
#     authorize!(:destroy, @santa)
#     @santa.destroy
#
#     respond_with(@santa, location: member_dashboard_index_path, notice: "Santa was successfully deleted")
#   end
#
  def index
    @santas = Santa.all.where(list_id: find_list).order(id: :desc)
    authorize!(:show, @santa)
  end

private

#   def santa_params
#     params.require(:santa).permit(:name, :email)
#   end

  def find_santa
    Santa.find(params[:id])
  end

  def find_list
    List.find(params[:list_id])
  end

end
