# Imports charge codes for a hotel.
#
# Usage: rake pms:charge_code_import[HOTEL_CODE,FILE_PATH]
namespace :pms do
  desc "Imports a CSV charge code file into a charge codes table"
  task :charge_code_import, [:hotel_code, :filename] => :environment do |task, args|
    hotel_code = args[:hotel_code]
    filename = args[:filename]

    PAYMENT = ['FC']
    OTHERS = ['C', 'PK']

    if hotel_code && filename
      hotel = Hotel.find_by_code(hotel_code)

      if hotel
        row_num = 2

        CSV.foreach(filename, headers: true, header_converters: :symbol) do |row|
          # Convert the row into a hash using the headers as the keys
          attributes = row.to_hash

          # Remove extra spaces
          attributes.update(attributes) { |key, value| value && value.strip }

          # Determine the charge code type
          if PAYMENT.include?(attributes[:tc_transaction_type])
            type = :PAYMENT
          elsif OTHERS.include?(attributes[:tc_transaction_type])
            type = :OTHERS
          end

          charge_code = hotel.charge_codes.build(charge_code: attributes[:trx_code], description: attributes[:d3], charge_code_type: type)

          p "Warning: Row #{row_num} - Invalid charge code: #{charge_code.errors.full_messages.to_sentence}" unless charge_code.save

          row_num += 1
        end

        p 'Import Complete'
      else
        p 'Error: hotel could not be found'
      end
    else
      p 'Usage: rake pms:charge_code_import <hotel_code> <filename>'
      p ' - hotel_code: identifier of hotel_code'
      p ' - filename: CSV file and path to import'
    end
  end
end
