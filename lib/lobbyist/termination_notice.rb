module Lobbyist
  class TerminationNotice < Lobbyist::Base
    
    attr_accessor :id, :company_id, :dismissed, :created_at, :updated_at
    
    def company
      @company
    end
    
    def company=(attributes)
      @company = Company.new(attributes)
    end
    
    def self.list(params = {})
      create_from_response(get('/v1/termination_notices.json', params))
    end
    
    def self.dismiss(id)
      create_from_response(put("/v1/termination_notices/#{id}/dismiss.json", {'termination_notice' => {}}))
    end
    
  end
end