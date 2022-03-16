module RssTogether
  class Groups::TransfersController < Groups::BaseController
    include AfterCommitEverywhere

    before_action :prepare_group
    before_action :prepare_transfer, only: [:show, :new, :create, :destroy]
    before_action :redirect_if_transfer_in_flight, only: [:new, :create]

    def show
    end

    def new
      @transfer = @group.build_group_transfer
    end

    def create
      @transfer = @group.build_group_transfer(group_transfer_params)

      ActiveRecord::Base.transaction do
        @transfer.save!
        after_commit { GroupMailer.with(transfer: @transfer).transfer_email.deliver_later }
      end

      flash[:success] = "Group transfer initiated"
      redirect_to group_transfer_path(@group)
    rescue ActiveRecord::RecordInvalid
      flash.now[:alert] = "We found some input errors, fix them and submit the form again"
      render :new, status: :unprocessable_entity
    end

    def destroy
      flash[:success] = "Group transfer cancelled"
      @transfer.destroy
      redirect_to group_transfer_path(@group), status: :see_other
    end

    private

    def prepare_transfer
      @transfer = @group.group_transfer
      @transfer.present? ? authorize(@transfer) : skip_authorization
    end

    def redirect_if_transfer_in_flight
      redirect_to group_transfer_path(@group) if @transfer.present?
    end

    def group_transfer_params
      params.require(:group_transfer).permit(:recipient_id)
    end
  end
end
