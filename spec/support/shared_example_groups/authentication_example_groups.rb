shared_examples_for "action requiring authentication" do

  before { subject }

  it 'should redirect to the sign in page' do
    expect(response).to redirect_to(new_user_session_url)
  end

end
