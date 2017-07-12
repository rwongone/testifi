shared_context "with authenticated requests" do
  def authenticate(user)
    cookies['Authorization'] = 'X'
    allow(Auth).to receive(:decode).and_return({ 'user_id' => user.id })
  end
end

shared_context "with JSON responses" do
  let(:json_response) { ActiveSupport::JSON.decode(response.body) }
end

shared_context "with mailing" do
  before do
    ActiveJob::Base.queue_adapter = :test
  end
end

shared_examples "an admin-only GET endpoint" do |endpoint|
  let(:student) { create(:student) }

  before do
    authenticate(student)
  end

  it "is inaccessible to student users" do
    get endpoint
    expect(response).to have_http_status(403)
  end
end

shared_examples "an admin-only POST endpoint" do |endpoint|
  let(:student) { create(:student) }

  before do
    authenticate(student)
  end

  it "is inaccessible to student users" do
    post endpoint
    expect(response).to have_http_status(403)
  end
end
