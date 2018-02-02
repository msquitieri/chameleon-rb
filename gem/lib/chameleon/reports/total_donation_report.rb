require 'rubyXL'
require 'chameleon/reports/abstract_report'

class TotalDonationReport < AbstractReport
  MAX_COLUMN_WIDTH = 30
  DEFAULT_FONT_NAME = 'Calibri'
  DEFAULT_FONT_SIZE = 12

  def self.generate!(donor_infos, tiers, outfile)
    workbook = RubyXL::Workbook.new

    all_donor_sheet = workbook.worksheets.first
    all_donor_sheet.sheet_name = 'All Donors'

    write_headers(all_donor_sheet)

    donor_infos.sort_by!(&:total)

    donor_infos.each_with_index do |donor, index|
      write_donor(all_donor_sheet, donor, index + 1)
    end

    tiers.each do |range|
      tier_sheet = workbook.add_worksheet("$#{range.first} - $#{range.last}")

      write_headers(tier_sheet)

      i = 1
      donor_infos.each do |donor|
        if donor.in_tier?(range)
          write_donor(tier_sheet, donor, i)
          i = i + 1
        end
      end
    end

    workbook.write(outfile)
  end

  private

  def self.write_donor(sheet, donor_info, index)
    sheet.add_cell(index, 0, donor_info.name.strip)
    sheet.add_cell(index, 1, donor_info.first_name)
    sheet.add_cell(index, 2, donor_info.last_name)
    sheet.add_cell(index, 3, donor_info.total).set_number_format('$###,##0.00')
  end

  def self.write_headers(worksheet)
    worksheet.change_column_width(0, MAX_COLUMN_WIDTH)
    worksheet.change_column_width(1, MAX_COLUMN_WIDTH / 2)
    worksheet.change_column_width(2, MAX_COLUMN_WIDTH / 2)
    worksheet.change_column_width(3, MAX_COLUMN_WIDTH / 2)

    (0..3).to_a.each do |index|
      worksheet.change_column_font_name(index, DEFAULT_FONT_NAME)
      worksheet.change_column_font_size(index, DEFAULT_FONT_SIZE)
    end

    worksheet.change_row_font_name(0, DEFAULT_FONT_NAME)
    worksheet.change_row_font_size(0, DEFAULT_FONT_SIZE)
    worksheet.change_row_bold(0, true)

    worksheet.add_cell(0, 0, 'Full Name')
    worksheet.add_cell(0, 1, 'First Name')
    worksheet.add_cell(0, 2, 'Last Name')
    worksheet.add_cell(0, 3, 'Amount')
  end
end