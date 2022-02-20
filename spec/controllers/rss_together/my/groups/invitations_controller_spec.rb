require 'rails_helper'

module RssTogether
  RSpec.describe My::Groups::InvitationsController, type: :controller do
    routes { Engine.routes }

    let(:membership) { create(:membership) }
    let(:group) { membership.group }
    let(:account) { membership.account }
    let(:invitation) { create(:invitation, group: group) }

    before { sign_in account }

    describe "GET #index" do
      before { invitation; get :index, params: { group_id: group.id } }

      it { expect(assigns(:invitations)).not_to be_empty }
      it { expect(response).to render_template(:index) }
    end

    describe "GET #new" do
      before { get :new, params: { group_id: group.id } }

      it { expect(assigns(:form).invitation).to be_new_record }
      it { expect(response).to render_template(:new) }
    end

    describe "POST #create" do
      before { post :create, params: { group_id: group.id, new_invitation_form: params } }

      context "with valid params" do
        let(:params) { attributes_for(:invitation) }
        it { expect(assigns(:form).invitation).to be_valid }
        it { expect(response).to redirect_to(my_group_invitations_path(group)) }
      end

      context "with invalid params" do
        let(:params) { attributes_for(:invitation, :invalid) }
        it { expect(assigns(:form).invitation).not_to be_valid }
        it { expect(response).to render_template(:new) }
      end
    end

    describe "DELETE #destroy" do
      before { delete :destroy, params: { group_id: group.id, id: invitation.id } }

      it { expect(assigns(:invitation)).to be_destroyed }
      it { expect(response).to redirect_to(my_group_invitations_path(group)) }
    end
  end
end
