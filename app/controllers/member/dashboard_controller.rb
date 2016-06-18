class Member::DashboardController < Member::BaseController

  def index
    authorize!(:show, :member_dashboard)
    @lists = List.all.where(user_id: current_user.id)
  end

end
