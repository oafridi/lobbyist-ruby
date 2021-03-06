module Lobbyist
  module V2

    class DataUpload < Lobbyist::V2::Base
      attr_accessor :id, :company_id, :filename, :status, :created_at, :updated_at

      def self.create(params = {})
        create_from_response(post("/v2/data_uploads.json", params))
      end

      def self.update(id, params = {})
        create_from_response(put("/v2/data_uploads/#{id}.json", params))
      end

      def self.find(id, params = {})
        create_from_response(get("/v2/data_uploads/#{id}.json", params))
      end

      def self.list(params = {})
        create_collection_from_response(get('/v2/data_uploads.json', params))
      end

      def self.process_file(id, params = {})
        create_from_response(put("/v2/data_uploads/#{id}/process-file.json", params))
      end
    end

  end
end
