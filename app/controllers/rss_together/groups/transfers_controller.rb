module RssTogether
  class Groups::TransfersController < Groups::BaseController
    before_action :prepare_group
    before_action :prepare_transfer, only: [:show, :new, :create, :destroy]
    before_action :redirect_if_transfer_in_flight, only: [:new, :create]

    def show
    end

    def new
      @form = GroupTransferForm.new(@group)
    end

    def create
      @form = GroupTransferForm.new(@group, group_transfer_form_params)
      if @form.submit
        flash[:success] = "Group transfer initiated"
        redirect_to group_transfer_path(@group), status: :see_other
      else
        flash.now[:alert] = "We found some input errors, fix them and submit the form again"
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      @transfer.destroy!

      flash[:success] = "Group transfer cancelled"
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

    def group_transfer_form_params
      params.require(:group_transfer_form).permit(:recipient_id)
    end
  end
end
