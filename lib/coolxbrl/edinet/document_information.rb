module CoolXBRL
  module EDINET
    class DocumentInformation
      attr_accessor :security_code, :filing_date, :quarter, :document_id

      def initialize(doc)

      end

      def attributes
        {
          security_code: code,
          filing_date:   filing_date,
          quarter:       quarter,
          document_id:   document_id
        }
      end


    end
  end
end