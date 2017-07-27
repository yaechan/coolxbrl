module CoolXBRL
  module EDINET
    class XBRL
      class DataSet < Array
        include Set

        def to_csv
          self.map do |data|
            data_row = data.to_csv
            block_given? ? yield data_row : data_row
          end
        end
      end
    end
  end
end