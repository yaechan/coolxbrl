module CoolXBRL
  module EDINET
    class XBRL
      class Data
        attr_accessor :value, :context_ref, :unit_ref, :decimals, :context_label

        def initialize(value, context_ref, unit_ref, decimals)
          @value         = value
          @context_ref   = context_ref
          @unit_ref      = unit_ref
          @decimals      = decimals
          @context_label = create_context_label(context_ref)
          @period        = create_period(context_ref)
        end

        def create_context_label(context_ref)
          context_ref.scan(/(?<=Instant\_|Duration\_|Member\_).+?Member/).inject([]) do |stack, context|
            stack << CoolXBRL::EDINET::Label.get_context_label(context)
          end
        end

        def create_period(context_ref)
          CoolXBRL::EDINET::XBRL.create_period(context_ref)
        end
      end
    end
  end
end