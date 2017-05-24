require 'rails_helper'

RSpec.describe "Assignments", type: :request do
  describe "GET /assignments" do
    it "works! (now write some real specs)" do
      get assignments_index_path
      expect(response).to have_http_status(200)
    end
  end
end
