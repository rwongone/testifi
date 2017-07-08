RSpec.shared_context "with authenticated requests" do
  def authenticate(user)
    cookies['Authorization'] = 'X'
    allow(Auth).to receive(:decode).and_return({ 'user_id' => user.id })
  end
end
