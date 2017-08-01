require "coolxbrl/edinet/presentation/node_set"
require "coolxbrl/edinet/presentation/node"

module CoolXBRL
  module EDINET
    class Presentation
      CONSOLIDATED_BALANCE_SHEET                     = "rol_ConsolidatedBalanceSheet"
      CONSOLIDATED_STATEMENT_OF_INCOME               = "rol_ConsolidatedStatementOfIncome"
      CONSOLIDATED_STATEMENT_OF_CHANGES_IN_EQUITY    = "rol_ConsolidatedStatementOfChangesInEquity"
      CONSOLIDATED_STATEMENT_OF_COMPREHENSIVE_INCOME = "rol_ConsolidatedStatementOfComprehensiveIncome"
      CONSOLIDATED_STATEMENT_OF_CASH_FLOWS_INDIRECT  = "rol_ConsolidatedStatementOfCashFlows-indirect"
      BALANCE_SHEET                                  = "rol_BalanceSheet"
      STATEMENT_OF_INCOME                            = "rol_StatementOfIncome"
      STATEMENT_OF_CHANGES_IN_EQUITY                 = "rol_StatementOfChangesInEquity"

      class << self
        def parse(doc)
          #doc = CoolXBRL::EDINET.get_file(dir, "*_pre.xml")
          get_financial_accounts(doc)
        end

        def parse_table(doc, consolidated, table)
          get_financial_accounts(doc, select_table(consolidated, table))
        end

        def select_table(consolidated, table)
          case table
          when :bs
            consolidated ? CONSOLIDATED_BALANCE_SHEET : BALANCE_SHEET
          when :pl
            consolidated ? CONSOLIDATED_STATEMENT_OF_INCOME : STATEMENT_OF_INCOME
          when :cs
            consolidated ? CONSOLIDATED_STATEMENT_OF_CHANGES_IN_EQUITY : STATEMENT_OF_CHANGES_IN_EQUITY
          when :ci
            consolidated ? CONSOLIDATED_STATEMENT_OF_COMPREHENSIVE_INCOME : raise# "SelectTableError"
          when :cf
            consolidated ? CONSOLIDATED_STATEMENT_OF_CASH_FLOWS_INDIRECT : raise# "SelectTableError"
          else
            raise "SelectTableError"
          end
        end

        def get_financial_accounts(doc, table="")
          tables = doc.xpath("//link:presentationLink[contains(./@xlink:role, 'http://disclosure.edinet-fsa.go.jp/role/jppfs/#{table}')]")

          create_node_set tables
        end

        def create_node_set(tables)
          #hash = {}
          tables.inject(NodeSet.new) do |node_set, table|
            #consolidated_flag = consolidated?(table)
            axis = get_axis(table)

            Node.clear_class_variables
            table.xpath("link:presentationArc").each do |arc|
              parent_name = arc.at_xpath("@xlink:from").to_s
              child_name  = arc.at_xpath("@xlink:to").to_s

              Node.new(parent:            { name: parent_name, locator: table.xpath("link:loc[@xlink:label='#{parent_name}']/@xlink:href").to_s },
                       child:             { name: child_name, locator: table.xpath("link:loc[@xlink:label='#{child_name}']/@xlink:href").to_s },
                       order:             arc.at_xpath("@order").to_s,
                       preferred_label:   arc.at_xpath("@preferredLabel").to_s,
#                       consolidated_flag: consolidated_flag)
                       axis:              axis
            end

            #hash[table.xpath("@xlink:role").to_s] = Node.top_node
            node_set << Node.top_node
          end
          #hash
        end

        def consolidated?(table)
          table.at_xpath("link:presentationArc[@xlink:from='jppfs_cor_ConsolidatedOrNonConsolidatedAxis' and @xlink:to='jppfs_cor_NonConsolidatedMember']").nil?
        end

        def get_axis(table)
          pp table.xpath("link:presentationArc[starts-with(./@xlink:to, 'jppfs_cor_') and contains(./@xlink:to, 'Member')]/@xlink:to").map {|to| to.to_s.gsub(/^jppfs\_cor\_/, "") }
        end
      end
    end
  end
end