require 'writeexcel'
require 'chameleon/reports/abstract_report'

class TotalDonationReport < AbstractReport
  def self.generate!(donor_infos, tiers, outfile)
    workbook = WriteExcel.new(outfile)

    all_donor_sheet = workbook.add_worksheet('All Donors')

    header_format = workbook.add_format
    header_format.set_bold

    write_headers(all_donor_sheet, header_format)

    donor_infos.sort_by!(&:total)

    donor_infos.each_with_index do |donor, index|
      write_donor(all_donor_sheet, donor, index + 1)
    end

    tiers.each do |range|
      tier_sheet = workbook.add_worksheet("$#{range.first} - $#{range.last}")

      write_headers(tier_sheet, header_format)

      i = 1
      donor_infos.each do |donor|
        if donor.in_tier?(range)
          write_donor(tier_sheet, donor, i)
          i = i + 1
        end
      end
    end

    workbook.close
  end

  private

  def self.write_donor(sheet, donor_info, index)
    sheet.write(index, 0, donor_info.name)
    sheet.write(index, 1, donor_info.first_name)
    sheet.write(index, 2, donor_info.last_name)
    sheet.write(index, 3, donor_info.total)
  end

  def self.write_headers(worksheet, format)
    worksheet.write(0, 0, 'Full Name', format)
    worksheet.write(0, 1, 'First Name', format)
    worksheet.write(0, 2, 'Last Name', format)
    worksheet.write(0, 3, 'Amount', format)
  end
end