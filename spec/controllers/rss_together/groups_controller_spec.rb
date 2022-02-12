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

    describe "DELETE #destroy" do
      before { delete :destroy, params: { id: group.id } }

      it { expect(assigns(:membership)).to be_destroyed }
      it { expect(response).to redirect_to(groups_path) }
    end
  end
end
