require 'rails_helper'

RSpec.describe HomeController do

  describe 'GET index' do
    subject { get :index }
    it { should render_template(:index) }
  end

  describe 'GET health_check' do
    before { get :health_check }
    it { should render_template nil }
  end

end
