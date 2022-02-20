require 'rails_helper'

module RssTogether
  RSpec.describe ReaderController, type: :controller do
    routes { Engine.routes }

    let(:account) { create(:account) }

    before { sign_in account }

    describe "GET #show" do
      before { get :show }
      it { expect(response).to render_template(:show) }
    end
  end
end
