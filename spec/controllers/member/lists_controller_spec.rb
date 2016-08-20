require 'rails_helper'

RSpec.describe Member::ListsController do

  describe 'GET new' do
    subject { get :new }

    authenticated_as(:member) do
      it { should be_success }
    end

    it_behaves_like "action requiring authentication"
    it_behaves_like "action authorizes roles", [:member, :admin]
  end

  describe 'POST create' do
    subject(:create_list) { post :create, list: params }
    let(:params) { {} }

    authenticated_as(:member) do

      context "with valid parameters" do
        let(:params) do
          {
            name: "Family Secret Santa",
            gift_day: Date.tomorrow
          }
        end

        it "creates a List object with the given attributes" do
          create_list

          list = List.find_by(name: params[:name])
          expect(list).to be_present
        end

        it { should redirect_to(member_dashboard_index_path) }
      end

      context "with invalid parameters" do
        let(:params) { {name: nil, gift_day: Date.yesterday} }
        specify { expect { create_list }.not_to change(List, :count) }
      end
    end

    it_behaves_like "action requiring authentication"
    it_behaves_like "action authorizes roles", [:member, :admin]
  end

  describe 'GET edit' do
    subject { get :edit, id: list.id }
    let(:user) { FactoryGirl.create(:user, :member) }
    let(:other_user) { FactoryGirl.create(:user, :member) }
    let(:list) { FactoryGirl.create(:list, user_id: user.id) }

    context 'user can edit their own list' do
      authenticated_as(:user) do
        it { should be_success }
      end
    end

    context 'user cannot edit a list they do not own' do
      authenticated_as(:other_user) do
        it { should_not be_success }
      end
    end

    context "when the gift day has occurred" do
      authenticated_as(:user) do
        scenario "user cannot update list" do
          list.update_attributes(gift_day: Date.yesterday)
          should_not be_success
        end
      end
    end

    it_behaves_like "action requiring authentication"
    it_behaves_like "action authorizes roles", [:member, :admin]
  end

  describe 'POST update' do
    subject(:update_list) { post :update, id: target_list.id, list: params }
    let(:params) { {} }
    let(:user) { FactoryGirl.create(:user, :member) }
    let(:other_user) { FactoryGirl.create(:user, :member) }
    let(:target_list) { FactoryGirl.create(:list, user_id: user.id) }

    authenticated_as(:user) do

      context "with valid parameters" do
        let(:params) { {name: "JK's List", gift_day: Date.tomorrow} }

        it "updates a List object with the given attributes" do
          update_list

          target_list.reload
          expect(target_list.name).to eq("JK's List")
          expect(target_list.user_id).to eq(user.id)
        end

        it { should redirect_to(member_dashboard_index_path) }
      end

      context "with invalid parameters" do
        let(:params) { {name: "", gift_day: Date.yesterday} }

        it "doesn't update the List" do
          update_list
          expect(target_list.reload.name).not_to eq(params[:name])
        end
      end

      context "when the gift day has occurred" do
        let(:params) { {name: "JK's List"} }

        scenario "user cannot update list" do
          target_list.update_attributes(gift_day: Date.yesterday)
          expect(target_list.reload.name).not_to eq(params[:name])
          should redirect_to(member_dashboard_index_path)
        end
      end
    end

    authenticated_as(:other_user) do
      it { should_not be_success }
    end

    it_behaves_like "action requiring authentication"
    it_behaves_like "action authorizes roles", [:member, :admin]
  end

  describe 'DELETE destroy' do
    subject { delete :destroy, id: target_list.id }
    let!(:target_list) { FactoryGirl.create(:list, user_id: user.id) }
    let(:user) { FactoryGirl.create(:user, :member) }
    let(:other_user) { FactoryGirl.create(:user, :member) }

    authenticated_as(:user) do
      it "deletes the list" do
        expect { subject }.to change{List.count}.by(-1)
      end
      it { should redirect_to(member_dashboard_index_path) }

      scenario "when the gift day has occurred" do
        target_list.update_attributes(gift_day: Date.yesterday)
        expect { subject }.to_not change{List.count}
        should redirect_to(member_dashboard_index_path)
      end
    end

    authenticated_as(:other_user) do
      it "doesn't delete the list" do
        expect { subject }.to_not change{List.count}
      end
      it { should redirect_to(root_path) }
    end

    it_behaves_like "action requiring authentication"
    it_behaves_like "action authorizes roles", [:member, :admin]
  end

  describe 'PATCH lock_and_assign' do
    subject { patch :lock_and_assign, list_id: target_list.id }

    let(:user) { FactoryGirl.create(:user, :member) }
    let(:target_list) { FactoryGirl.create(:list, user_id: user.id) }
    let(:instance) { double }

    authenticated_as(:user) do
      it "shuffles users and assigns them a recipient" do
        expect(List::ShuffleAndAssignSantas).to receive(:new).with(anything).and_return(instance)
        expect(instance).to receive(:assign_and_email)

        subject

        expect(flash[:success]).to be_present
        should render_template :show
      end
    end

    it_behaves_like "action requiring authentication"
    it_behaves_like "action authorizes roles", [:member, :admin]
  end

end
