module Lobbyist
  module V2

    class CustomerCallMetrics < Lobbyist::V2::Base

      def self.list(company_id, params = {})
        create_from_response(get("/v2/companies/#{company_id}/customer_call_metrics.json", params))
      end
      
    end

  end
end
