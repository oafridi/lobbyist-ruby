module Lobbyist
  module V2

    class ReviewChallenge < Lobbyist::V2::Base
      attr_accessor :id, :review_id , :reason, :status, :read, :created_at, :updated_at

      def self.list(review_id, params = {})
        create_collection_from_response(get("/v2/reviews/#{review_id}/challenges.json", params))
      end
      
      def self.update(id, company_id, params = {})
        create_from_response(put("/v2/reviews/#{review_id}/challenges/#{id}.json", {'review_challenge' => params}))
      end

      def self.find(id, company_id, params = {})
        create_from_response(get("/v2/reviews/#{review_id}/challenges/#{id}.json", {review_challenge: params}))
      end

    end

  end
end
