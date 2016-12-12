require 'rails_helper'
require 'webmock/rspec'

RSpec.describe Member::ListsController do
  let(:user) { FactoryGirl.create(:user, :member) }

  describe 'GET new' do
    subject { get :new }

    authenticated_as(:member) do
      it { should be_success }
    end

    it_behaves_like 'action requiring authentication'
    it_behaves_like 'action authorizes roles', [:member, :admin]
  end

  describe 'POST create' do
    subject(:create_list) { post :create, list: params }
    let(:params) { {} }

    authenticated_as(:member) do

      context 'with valid parameters' do
        let(:params) do
          {
            name: 'Family Secret Santa',
            gift_day: Date.tomorrow,
            gift_value: 20
          }
        end

        it 'creates a List object with the given attributes' do
          create_list

          list = List.find_by(name: params[:name])
          expect(list).to be_present
          expect(list.gift_day).to eq(Date.tomorrow)
          expect(list.gift_value).to eq(20)
        end

        it "takes the user to the santas page to add santas" do
          create_list
          should redirect_to(member_list_santas_path(List.order(:created_at).last))
        end
      end

      context 'with invalid parameters' do
        let(:params) { {name: nil, gift_day: Date.yesterday} }
        specify { expect { create_list }.not_to change{ List.count } }
      end
    end

    it_behaves_like 'action requiring authentication'
    it_behaves_like 'action authorizes roles', [:member, :admin]
  end

  describe 'PATCH lock_and_assign' do
    subject { patch :lock_and_assign, list_id: list.id }
    let(:other_user) { FactoryGirl.create(:user, :member) }
    let(:list)       { FactoryGirl.create(:list, user_id: user.id) }
    let!(:santas)    { FactoryGirl.create_list(:santa, 5, list_id: list.id) }
    let(:instance)   { double }

    context 'user can lock and assign their own list' do
      authenticated_as(:user) do
        it { should be_success }

        it 'shuffles and assigns the santas in the list' do
          expect(List::ShuffleAndAssignSantas).to receive(:new).with(list).and_return(instance)
          expect(instance).to receive(:assign_and_email)
          subject
          expect(flash[:success]).to be_present
        end

        context 'there are less than three santas' do
          let!(:santas) { FactoryGirl.create_list(:santa, 2, list_id: list.id) }

          it 'will not run, and will display an error' do
            expect(List::ShuffleAndAssignSantas).to_not receive(:new).with(list)
            expect(instance).to_not receive(:assign_and_email)
            subject
            expect(flash[:danger]).to be_present
          end
        end
      end
    end

    context 'user cannot lock and assign a list they do not own' do
      authenticated_as(:other_user) do
        it { should_not be_success }
      end
    end
    it_behaves_like 'action requiring authentication'
    it_behaves_like 'action authorizes roles', [:member, :admin]
  end

  describe 'POST copy_list' do
    subject { post :copy_list, list_id: list_with_santas.id }
    let!(:list_with_santas) { FactoryGirl.create(:list, :with_santas, user: user) }

    context 'user can copy their own list' do
      authenticated_as(:user) do

        context 'where the gift day of the list is in the past' do
          before { list_with_santas.update_attribute(:gift_day, Date.yesterday) }

          it 'should copy the list with the santas' do
            expect { subject }.to change{ List.count }.by(1)
            new_list = List.order(:created_at).last
            expect(new_list.santas.count).to eq(list_with_santas.santas.count)
            expect(new_list.name).to eq(list_with_santas.name)
            expect(new_list.gift_value).to eq(list_with_santas.gift_value)
          end
          it 'sets a flash for the user' do
            subject
            expect(controller).to set_flash[:success].to('List was successfully copied. Please update details below.')
          end
        end

        context 'where the gift day of the list is not in the past' do
          # This is an edge case since the button will not be available. The user
          # will be redirected to edit the list with a flash.
          before { list_with_santas.update_attributes(gift_day: Date.tomorrow) }

          it 'should not copy the list and redirect the user with a flash' do
            expect { subject }.to_not change{ List.count }
            expect(controller).to set_flash[:warning].to("List is not locked, please edit it instead!")
          end
        end

        context 'if the list is locked' do
          before do
            list_with_santas.update_attribute(:is_locked, true)
          end

          it 'should copy the list with the santas' do
            expect { subject }.to change{ List.count }.by(1)
            new_list = List.order(:created_at).last
            expect(new_list.santas.count).to eq(list_with_santas.santas.count)
            expect(new_list.name).to eq(list_with_santas.name)
            expect(new_list.gift_value).to eq(list_with_santas.gift_value)
          end
          it 'sets a flash for the user' do
            subject
            expect(controller).to set_flash[:success].to('List was successfully copied. Please update details below.')
          end
        end
      end
    end

    it_behaves_like 'action requiring authentication'
    it_behaves_like 'action authorizes roles', [:member, :admin]
  end

  describe 'PATCH reveal_santas' do
    subject { patch :reveal_santas, list_id: list.id }
    let(:other_user) { FactoryGirl.create(:user, :member) }
    let(:list)       { FactoryGirl.create(:list, user_id: user.id) }

    context 'user can edit their own list' do
      authenticated_as(:user) do
        it { should be_success }

        it 'should set the revealed flag on the list to be true' do
          subject
          expect(list.reload.revealed).to be_truthy
        end

        it 'sets a flash for the user' do
          subject
          expect(controller).to set_flash[:success].to('List has been revealed!')
        end
      end
    end

    context 'user cannot edit a list they do not own' do
      authenticated_as(:other_user) do
        it { should_not be_success }
      end
    end
  end

  describe 'GET edit' do
    subject { get :edit, id: list.id }
    let(:other_user) { FactoryGirl.create(:user, :member) }
    let(:list)       { FactoryGirl.create(:list, user_id: user.id) }

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

    context 'when the list is locked' do
      authenticated_as(:user) do
        before { list.update_attribute(:is_locked, true) }
        it 'sends the user back to the dashboard and sets a flash' do
          subject
          expect(flash[:warning]).to be_present
          should redirect_to member_dashboard_index_path
        end
      end
    end

    it_behaves_like 'action requiring authentication'
    it_behaves_like 'action authorizes roles', [:member, :admin]
  end

  describe 'PATCH update' do
    subject(:update_list) { post :update, id: target_list.id, list: params }
    let(:params) { {} }
    let(:other_user) { FactoryGirl.create(:user, :member) }
    let(:target_list) { FactoryGirl.create(:list, user_id: user.id) }

    authenticated_as(:user) do

      context 'with valid parameters' do
        let(:params) do
          {
            name: "JK's List",
            gift_day: Date.tomorrow,
            gift_value: 20
          }
        end

        it 'updates a List object with the given attributes' do
          update_list

          target_list.reload
          expect(target_list.name).to eq("JK's List")
          expect(target_list.user_id).to eq(user.id)
          expect(target_list.gift_day).to eq(Date.tomorrow)
          expect(target_list.gift_value).to eq(20)
        end

        it { should redirect_to(member_dashboard_index_path) }
      end

      context 'with invalid parameters' do
        let(:params) { { name: '', gift_day: Date.yesterday, gift_value: -1 } }

        it 'does not update the List' do
          update_list
          expect(target_list.reload.name).not_to eq(params[:name])
        end
      end

      context 'when the gift day has occurred' do
        let(:params) { {name: "JK's List"} }

        scenario 'user cannot update list' do
          target_list.update_attributes(gift_day: Date.yesterday)
          expect(target_list.reload.name).not_to eq(params[:name])
          should redirect_to(member_dashboard_index_path)
        end
      end
    end

    authenticated_as(:other_user) do
      it { should_not be_success }
    end

    it_behaves_like 'action requiring authentication'
    it_behaves_like 'action authorizes roles', [:member, :admin]
  end

  describe 'DELETE destroy' do
    subject { delete :destroy, id: target_list.id }
    let!(:target_list) { FactoryGirl.create(:list, user_id: user.id) }
    let(:other_user) { FactoryGirl.create(:user, :member) }

    authenticated_as(:user) do
      it 'deletes the list' do
        expect { subject }.to change{ List.count }.by(-1)
      end

      it { should redirect_to(member_dashboard_index_path) }
    end

    authenticated_as(:other_user) do
      it 'does not delete the list' do
        expect { subject }.to_not change{ List.count }
      end
      it { should redirect_to(root_path) }
    end

    it_behaves_like 'action requiring authentication'
    it_behaves_like 'action authorizes roles', [:member, :admin]
  end

  describe "POST list_payment" do
    subject {
      post :list_payment,
      list_id: list.id,
      "payment_status"=>"Completed",
      "txn_id"=>"081563299T6312119",
      "receiver_email"=>"jgunnink@gmail.com",
      "business"=>"accounts@secretsanta.website",
      "mc_gross"=>"3.00",
      "mc_currency"=>"AUD",
      "item_number"=>list.id
    }
    let!(:list) { FactoryGirl.create(:list, :unpaid) }

    shared_examples_for "a payment error" do
      it "sends a transaction error" do
        instance = double
        expect(List::TransactionErrorNotification).to receive(:new).and_return(instance)
        expect(instance).to receive(:create_notification).with(new_payment, response)
        subject
      end

      it "doesn't create a new transaction record" do
        expect{ subject }.to_not change{ ProcessedTransaction.count }
      end

      it "updates the list limited status" do
        subject
        expect(list.reload.limited).to be_truthy
      end
    end

    context "when the PayPal response is VERIFIED" do
      before do
        stub_request(:post, "https://www.paypal.com/cgi-bin/webscr?cmd=_notify-validate").to_return(
        body: "VERIFIED"
        )
      end
      let!(:response) { "VERIFIED" }

      context "with valid parameters" do
        it "creates a new transaction record" do
          expect{ subject }.to change{ ProcessedTransaction.count }.by 1
        end

        it "updates the list limited status" do
          subject
          expect(list.reload.limited).to be_falsey
        end

        it "sends a payment confirmation" do
          instance = double
          expect(List::ThankyouNotification).to receive(:new).and_return(instance)
          expect(instance).to receive(:create_confirmation).with(list)
          subject
        end
      end

      context "when the payee email has been changed" do
        subject {
          post :list_payment,
          list_id: list.id,
          "payment_status"=>"Completed",
          "txn_id"=>"081563299T6312119",
          "receiver_email"=>"someoneelse@example.com",
          "business"=>"accounts@secretsanta.website",
          "mc_gross"=>"3.00",
          "mc_currency"=>"AUD",
          "item_number"=>"#{list.id}"
        }
        let!(:new_payment) do {
          "payment_status"=>"Completed",
          "txn_id"=>"081563299T6312119",
          "receiver_email"=>"someoneelse@example.com",
          "business"=>"accounts@secretsanta.website",
          "mc_gross"=>"3.00",
          "mc_currency"=>"AUD",
          "item_number"=>"#{list.id}",
          "list_id"=>"#{list.id}",
          "controller"=>"member/lists",
          "action"=>"list_payment"
          }
        end

        it_behaves_like "a payment error"
      end
    end

    context "when the PayPal response is not VERIFIED" do
      before do
        stub_request(:post, "https://www.paypal.com/cgi-bin/webscr?cmd=_notify-validate").to_return(
        body: "INVALID"
        )
      end
      let!(:response) { "INVALID" }

      let!(:new_payment) do {
        "payment_status"=>"Completed",
        "txn_id"=>"081563299T6312119",
        "receiver_email"=>"jgunnink@gmail.com",
        "business"=>"accounts@secretsanta.website",
        "mc_gross"=>"3.00",
        "mc_currency"=>"AUD",
        "item_number"=>"#{list.id}",
        "list_id"=>"#{list.id}",
        "controller"=>"member/lists",
        "action"=>"list_payment"
        }
      end
      it_behaves_like "a payment error"
    end
  end
end
