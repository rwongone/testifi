require 'rails_helper'

RSpec.describe "Problems", type: :request do
  describe "GET /problems" do
    it "works! (now write some real specs)" do
      get problems_index_path
      expect(response).to have_http_status(200)
    end
  end
end