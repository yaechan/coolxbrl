module CoolXBRL
  module EDINET
    class XBRL
      class DataSet < Array
        include Set

        def to_hash
          self.each_with_object({}) do |data, stack|
            context_ref = data.context_ref.scan(/(?<=Instant\_|Duration\_).+Member$/)[0]
            #context_ref = data.context_ref
            stack[context_ref] = { :label => data.context_label, :data => [] } unless stack.has_key?(context_ref)
            stack[context_ref][:data] << { :period => data.period, :value => data.value }
            stack[context_ref][:data].sort
          end
        end

        def has_context_ref?(context_ref)
          self.find {|data| data.context_ref == context_ref }
        end

        def sort
          self.sort_by{|data| data[:period] }
        end
      end
    end
  end
end