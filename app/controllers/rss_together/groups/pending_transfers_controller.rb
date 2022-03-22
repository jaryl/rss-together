module RssTogether
  class Groups::PendingTransfersController < Groups::BaseController
    before_action :prepare_group
    before_action :prepare_membership, only: [:show, :accept]
    before_action :prepare_transfer, only: [:show, :accept]

    def show
    end

    def accept
      ActiveRecord::Base.transaction do
        @transfer.destroy!
        @group.update!(owner: current_account)
      end

      flash[:success] = "You are now the owner of the group"
      redirect_to group_transfer_path(@group), status: :see_other
    end

    private

    def prepare_membership
      @membership = @group.memberships.find_by(account: current_account)
    end

    def prepare_transfer
      @transfer = @group.group_transfer if @group.group_transfer&.recipient&.account == current_account
      @transfer.present? ? authorize(@transfer, :accept?) : skip_authorization
    end
  end
end
