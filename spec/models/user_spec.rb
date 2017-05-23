require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#create' do
    let(:name) { "Larry Learner" }
    let(:email) { "larry@downtolearn.com" }
    let(:password) { "12345678" }
    let(:short_password) { "1234567" }

    it 'allows the creation of a user with password at least 8 chars long' do
      expect(User.create!(name: name, email: email, password: password, password_confirmation: password)).to have_attributes(name: name, email: email)
    end

    it 'rejects the creation of a user with password shorter than 8 chars' do
      expect(User.new(name: name, email: email, password: short_password, password_confirmation: short_password).valid?).to be false
    end
  end
end
