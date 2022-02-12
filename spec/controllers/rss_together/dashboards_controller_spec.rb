require 'rails_helper'

module RssTogether
  RSpec.describe DashboardsController, type: :controller do
    routes { RssTogether::Engine.routes }

    let(:membership) { create(:membership) }
    let(:group) { membership.group }
    let(:account) { membership.account }

    before { sign_in account }

    describe "GET #show" do
      before { get :show }

      it { expect(response).to render_template(:show) }
    end
  end
end
