require 'rails_helper'

module RssTogether
  RSpec.describe GroupsController, type: :controller do
    routes { Engine.routes }

    let(:membership) { create(:membership) }
    let(:group) { membership.group }
    let(:account) { membership.account }

    before { sign_in account }

    describe "GET #index" do
      before { get :index }

      it { expect(assigns(:groups)).not_to be_empty }
      it { expect(response).to render_template(:index) }
    end

    describe "GET #show" do
      before { get :show, params: { id: group.id } }

      it { expect(assigns(:group)).to be_present }
      it { expect(response).to render_template(:show) }
    end

    describe "GET #new" do
      before { get :new }

      it { expect(assigns(:group)).to be_new_record }
      it { expect(response).to render_template(:new) }
    end

    describe "POST #create" do
      before { post :create, params: { group: params } }

      context "with valid params" do
        let(:params) { attributes_for(:group) }
        it { expect(assigns(:group)).to be_valid }
        it { expect(response).to redirect_to(group_path(assigns(:group))) }
      end

      context "with invalid params" do
        let(:params) { attributes_for(:group, :invalid) }
        it { expect(assigns(:group)).not_to be_valid }
        it { expect(response).to render_template(:new) }
      end
    end

    describe "GET #edit" do
      before { get :edit, params: { id: group.id } }

      it { expect(assigns(:group)).to be_present }
      it { expect(response).to render_template(:edit) }
    end

    describe "PATCH #update" do
      before { patch :update, params: { id: group.id, group: params } }

      context "with valid params" do
        let(:params) { attributes_for(:group) }
        it { expect(assigns(:group)).to be_valid }
        it { expect(response).to redirect_to(group_path(assigns(:group))) }
      end

      context "with invalid params" do
        let(:params) { attributes_for(:group, :invalid) }
        it { expect(assigns(:group)).not_to be_valid }
        it { expect(response).to render_template(:edit) }
      end
    end

    describe "DELETE #destroy" do
      before { delete :destroy, params: { id: group.id } }
      it { expect(assigns(:group)).to be_destroyed }
      it { expect(response).to redirect_to(groups_path) }
    end
  end
end
