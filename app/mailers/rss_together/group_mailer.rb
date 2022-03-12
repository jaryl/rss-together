module RssTogether
  class GroupMailer < ApplicationMailer
    def transfer_email
      @transfer = params[:transfer]
      @group = @transfer.group
      @recipient = @transfer.recipient.account

      mail(to: @recipient.email, subject: "")
    end
  end
end
