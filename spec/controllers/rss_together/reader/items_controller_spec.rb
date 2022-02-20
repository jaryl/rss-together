require 'rails_helper'

module RssTogether
  module Reader
    RSpec.describe ItemsController, type: :controller do
      routes { Engine.routes }

      let(:membership) { create(:membership) }
      let(:group) { membership.group }
      let(:account) { membership.account }
      let(:subscription) { create(:subscription, group: group) }
      let(:item) { create(:item, feed: subscription.feed) }

      before { sign_in account }

      describe "GET #index" do
        before { item; get :index, params: { group_id: group.id } }

        it { expect(assigns(:items)).not_to be_empty }
        it { expect(response).to render_template(:index) }
      end

      describe "GET #show" do
        before { get :show, params: { group_id: group.id, id: item.id } }

        it { expect(assigns(:item)).to be_present }
        it { expect(response).to render_template(:show) }
      end
    end
  end
end
