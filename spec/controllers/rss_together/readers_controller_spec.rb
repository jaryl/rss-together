require 'rails_helper'

module RssTogether
  RSpec.describe ReadersController, type: :controller do
    routes { RssTogether::Engine.routes }

    let(:account) { create(:account) }

    before { sign_in account }

    describe "GET #show" do
      before { get :show }
      it { expect(response).to render_template(:show) }
    end
  end
end
