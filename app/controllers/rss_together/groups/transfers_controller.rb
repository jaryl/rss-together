module RssTogether
  class Groups::TransfersController < Groups::BaseController
    before_action :prepare_group
    before_action :prepare_transfer
    before_action :redirect_if_transfer_in_flight, only: [:new, :create]

    def show

    end

    def new
      @transfer = @group.build_group_transfer
    end

    def create
      @transfer = @group.build_group_transfer(group_transfer_params)
      if @transfer.save
        redirect_to group_transfer_path(@group)
      else
        render :new
      end
    end

    def destroy
      @transfer.destroy
      redirect_to group_transfer_path(@group), status: :see_other
    end

    private

    def prepare_transfer
      @transfer = @group.group_transfer
    end

    def redirect_if_transfer_in_flight
      redirect_to group_transfer_path(@group) if @transfer.present?
    end

    def group_transfer_params
      params.require(:group_transfer).permit(:recipient_id)
    end
  end
end
