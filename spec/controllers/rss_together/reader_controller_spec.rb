require 'rails_helper'

module RssTogether
  RSpec.describe ReaderController, type: :controller do
    routes { Engine.routes }

    let(:membership) { create(:membership) }
    let(:group) { membership.group }
    let(:account) { membership.account }

    before { sign_in account }

    describe "GET #show" do
      context "with group_id" do
        before { get :show, params: { group_id: group.id } }
        it { expect(response).to render_template(:show) }
      end

      context "without group_id" do
        before { get :show }
        it { expect(response).to redirect_to(reader_path(group_id: group.id)) }
      end
    end

    describe "GET #bookmarks" do
      before { get :bookmarks }
      it { expect(response).to render_template(:bookmarks) }
    end
  end
end
