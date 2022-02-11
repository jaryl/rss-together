require "rails_helper"

module RssTogether
  RSpec.describe GroupsController, type: :controller do
    routes { RssTogether::Engine.routes }

    let(:membership) { create(:membership) }
    let(:group) { membership.group }
    let(:account) { membership.account }

    before { sign_in account }

    describe "GET #index" do
      before { get :index }

      it { expect(assigns(:groups)).not_to be_empty }
      it { expect(response).to render_template(:index) }
    end
  end
end
