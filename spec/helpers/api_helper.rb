RSpec.shared_context "with authenticated requests" do
  let(:authenticated_user) { user || create(:user) }

  before do
    cookies['Authorization'] = 'X'
    allow(Auth).to receive(:decode).and_return({ 'user_id' => authenticated_user.id })
  end
end
