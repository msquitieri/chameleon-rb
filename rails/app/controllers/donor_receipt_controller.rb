class DonorReceiptController < ApplicationController
  def receipt
    @donor_receipt = DonationReceipt.new
    @donor_receipt.name = "Michael Squitieri"
    @donor_receipt.amount = 125.25

    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "receipt", template: 'donor_receipt/receipt.html.erb'   # Excluding ".pdf" extension.
      end
    end
  end
end