module CoolXBRL
  module EDINET
    class XBRL
      class DataSet < Array
        include Set

        def to_hash
          self.inject({}) do |stack, data|
            stack[data.context_ref] = { :label => data.context_label, :data => [] } unless stack.has_key?(data.context_ref)
            stack[data.context_ref][:data] << { :period => data.period, :value => data.value }
            stack
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