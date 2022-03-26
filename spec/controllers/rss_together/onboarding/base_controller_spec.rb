require 'rails_helper'

module RssTogether
  RSpec.describe Onboarding::BaseController, type: :controller do
    routes { Engine.routes }

    let(:profile) { create(:profile, onboarded: false) }
    let(:account) { profile.account }

    before { sign_in account }

    controller do
      skip_after_action :verify_authorized
      skip_after_action :verify_policy_scoped

      def index
        head :ok
      end

      def create
        head :ok
      end
    end

    describe "#redirect_if_already_onboarded" do
      before { get :index }

      context "with not onboarded account" do
        let(:profile) { create(:profile, onboarded: false) }
        it { expect(response).not_to be_redirect }
      end

      context "with already onboarded account" do
        let(:profile) { create(:profile, onboarded: true) }
        it { expect(response).to redirect_to(main_app.root_path) }
      end
    end

    describe "#update_onboarding_status" do

      context "with connected group" do
        before { create(:membership, account: account) }
        before { post :create }
        it { expect(profile.reload).to be_onboarded }
      end

      context "with no connected group" do
        before {}
        before { post :create }
        it { expect(profile.reload).not_to be_onboarded }
      end
    end
  end
end
