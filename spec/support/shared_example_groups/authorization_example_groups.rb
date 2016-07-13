shared_examples_for "unauthorized access to controller action" do

  it 'should redirect to the root page' do
    should redirect_to(root_path)
  end

end

shared_examples_for "action authorizes roles" do |authorized_roles|

  unauthorized_roles = User.roles.keys.map(&:to_sym) - authorized_roles
  unauthorized_roles.each do |role|
    authenticated_as(role) do
      it_behaves_like "unauthorized access to controller action"
    end
  end
end
