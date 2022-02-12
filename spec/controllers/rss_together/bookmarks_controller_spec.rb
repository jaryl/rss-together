require 'rails_helper'

module RssTogether
  RSpec.describe BookmarksController, type: :controller do
    routes { RssTogether::Engine.routes }

    let(:membership) { create(:membership) }
    let(:group) { membership.group }
    let(:account) { membership.account }
    let(:bookmark) { create(:bookmark, account: account) }

    before { sign_in account }

    describe "GET #index" do
      before { bookmark; get :index }

      it { expect(assigns(:bookmarks)).not_to be_empty }
      it { expect(response).to render_template(:index) }
    end

    describe "GET #show" do
      before { get :show, params: { id: bookmark.id } }

      it { expect(assigns(:bookmark)).to be_present }
      it { expect(response).to render_template(:show) }
    end
  end
end
