require 'helpers/rails_helper'

RSpec.describe User, type: :model do
  describe '#create' do
    let(:name) { "Larry Learner" }
    let(:email) { "larry@downtolearn.com" }
    let(:google_id) { "18y3fl3424" }

    it 'allows the creation of a user with name, email and google_id' do
      google_id_token = class_double("GoogleIDToken::Validator")
      validator = instance_double("GoogleIDToken::Validator")
      allow(users_controller).to receive(:params).and_return({code: 'somerandomcode'})
      expect(google_id_token).to receive(:new).and_return(validator)
      expect(validator).to receive(:check).with(code, google_client.id, google_client.id).and_return({
          sub: google_id,
          name: name,
          email: email
      })
      # TODO call controller method instead of User.create
      expect(User.create!(name: name, email: email, google_id: google_id)).to have_attributes(name: name, email: email, google_id: google_id)
    end
  end

  def google_client
    OpenStruct.new Rails.application.secrets.google_client
  end
end
