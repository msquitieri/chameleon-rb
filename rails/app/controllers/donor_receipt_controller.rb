class DonorReceiptController < ApplicationController
  def receipt
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "receipt", template: 'donor_receipt/receipt.html.erb'   # Excluding ".pdf" extension.
      end
    end
  end
end