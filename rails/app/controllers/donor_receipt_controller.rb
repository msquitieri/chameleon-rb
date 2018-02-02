class DonorReceiptController < ApplicationController
  def receipt
    @donor_receipt = DonationReceipt.new
    @donor_receipt.name = params[:name]
    @donor_receipt.amount = params[:amount]

    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "receipt", template: 'donor_receipt/receipt.html.erb'   # Excluding ".pdf" extension.
      end
    end
  end
end