require 'rubyXL'
require 'chameleon/models/donor_info'

class QuickbooksParser
  def self.parse(excel_file_path)
    excel_file = RubyXL::Parser.parse(excel_file_path)
    worksheet = excel_file.worksheets.first

    donor_information = worksheet.map do |row|
      has_cells = !!(row && row.cells && row.cells.first && row.cells.last)

      if has_cells && !row.cells.first.value.index('Total for').nil?
        DonorInfo.new(row.cells.first.value.gsub('Total for ', ''), row.cells.last.value)
      end
    end

    donor_information.compact!
    donor_information
  end
end