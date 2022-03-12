module RssTogether
  class GroupMailer < ApplicationMailer
    def invitation_email
      @invitation = params[:invitation]
      @group = @invitation.group
      @sender = @invitation.sender

      mail(to: @invitation.email, subject: "You've been invited to join #{@group.name} on RSSTogether")
    end

    def transfer_email
      @transfer = params[:transfer]
      @group = @transfer.group
      @recipient = @transfer.recipient.account

      mail(to: @recipient.email, subject: "Pending transfer of group #{@group.name} to you")
    end
  end
end
