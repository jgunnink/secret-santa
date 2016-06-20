class Member::DashboardController < Member::BaseController

  def index
    authorize!(:show, :member_dashboard)
    authorize!(:index, List)
    @lists = List.all.where(user_id: current_user.id).order(id: :desc)
  end

end
