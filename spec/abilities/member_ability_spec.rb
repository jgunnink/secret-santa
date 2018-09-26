require 'rails_helper'
require 'cancan/matchers'

describe MemberAbility do
  subject { ability }

  let(:ability) { MemberAbility.new(user) }
  let(:user) { FactoryBot.create(:user, :member) }

  it { should_not be_able_to(:show, :admin_controllers) }

  describe "showing Dashboards" do
    it { should be_able_to(:show, :member_dashboard) }
    it { should_not be_able_to(:show, :admin_dashboard) }
  end

  describe "managing Users" do
    it { should be_able_to(:manage, user) }
    it { should_not be_able_to(:manage, FactoryBot.create(:user, :member)) }
  end

  describe "managing lists" do
    it { should be_able_to(:manage, List) }

    context "user should not be able to manage other users lists" do
      let!(:other_user) { FactoryBot.create(:user, :member) }
      it { should_not be_able_to(:manage, FactoryBot.create(:list, user_id: other_user.id)) }
    end
  end
end
