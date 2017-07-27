module CoolXBRL
  module EDINET
    class XBRL
      class DataSet < Array
        include Set

        def to_hash
          self.each_with_object({}) do |data, stack|
            context_ref = data.context_ref.scan(/(?<=Instant\_|Duration\_).+Member$/)
            stack[context_ref] = { :label => data.context_label, :data => [] } unless stack.has_key?(context_ref)
            stack[context_ref][:data] << { :period => data.period, :value => data.value }
          end

          #self.map do |data|
          #  data_row = data.to_csv
          #  block_given? ? yield(data_row) : data_row
          #end
        end
      end
    end
  end
end