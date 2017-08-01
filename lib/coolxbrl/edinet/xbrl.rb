require "coolxbrl/edinet/xbrl/data_set"
require "coolxbrl/edinet/xbrl/data"
require "pry"

module CoolXBRL
  module EDINET
    class XBRL
      class << self
        def parse(xbrl_doc)
          #get_data(xbrl_doc)
        end

        def get_data(name, preferred_label, consolidated_flag)
          doc = CoolXBRL::EDINET.xbrl
          doc.xpath("//#{name.gsub(/(?<=jppfs\_.{3}|jp.{3}\d{6}\-.{3}\_[EG]\d{5}\-\d{3})_|\_\d+$/, "_" => ":")}")
             .each_with_object(DataSet.new) do |data, stack|
            context_ref = data.at_xpath("@contextRef").to_s
            stack << Data.new(data.at_xpath("text()").to_s,
                              context_ref,
                              data.at_xpath("@unitRef").to_s,
                              data.at_xpath("@decimals").to_s) if consolidated_or_nonconsolidated?(context_ref,
                                                                                                   consolidated_flag) &&
                                                                  period_start_or_end?(context_ref, preferred_label) &&
                                                                  !stack.has_context_ref?(context_ref)
          end
        end

        def consolidated_or_nonconsolidated?(context_ref, consolidated_flag)
          (/\_NonConsolidatedMember/ =~ context_ref).nil? == consolidated_flag
        end

        def period_start_or_end?(context_ref, preferred_label)
          return true unless preferred_label == "http://www.xbrl.org/2003/role/periodStartLabel" ||
                             preferred_label == "http://www.xbrl.org/2003/role/periodEndLabel"

          doc = CoolXBRL::EDINET.xbrl
          current_fiscal_term_end_date   = doc.at_xpath("//jpdei_cor:EndDateOfQuarterlyOrSemiAnnualPeriodOfNextFiscalYearDEI[@xsi:nil!='true']")
          current_fiscal_term_end_date ||= doc.at_xpath("//jpdei_cor:CurrentFiscalYearEndDateDEI/text()").to_s
          comparative_period_end_date    = doc.at_xpath("//jpdei_cor:ComparativePeriodEndDateDEI/text()").to_s

          period_label = create_period(context_ref, "-")
          return (preferred_label == "http://www.xbrl.org/2003/role/periodStartLabel" &&
                  (Date.parse(period_label) == (Date.parse(comparative_period_end_date) + 1).prev_year - 1 ||
                   Date.parse(period_label) == (Date.parse(current_fiscal_term_end_date) + 1).prev_year - 1)) ||
                 (preferred_label == "http://www.xbrl.org/2003/role/periodEndLabel" &&
                  (period_label == current_fiscal_term_end_date ||
                   period_label == comparative_period_end_date))
        end

        def create_period(context_ref, date_sep="/")
          doc = CoolXBRL::EDINET.xbrl
          doc.xpath("//xbrli:context[@id='#{context_ref}']/xbrli:period/*/text()").map do |text|
            text.to_s.gsub(/\-/, date_sep)
          end.to_a.join("-")
        end
      end
    end
  end
end