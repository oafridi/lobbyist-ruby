module Lobbyist
  class Base
    # Initialize the nonce to nil.
    @@nonce = nil
    
    def initialize(attributes)
      attributes.each do |k,v|
        define_attribute(k, v.is_a?(Hash)) unless self.respond_to?("#{k}=")
        self.send "#{k}=", v
      end
    end
    
    def self.nonce
      return @@nonce || Time.now.utc.to_s
    end
    
    def self.nonce=(nonce)
      @@nonce = nonce
    end
    
    def self.last_message
      return @@last_message
    end
    
    def self.last_message=(message)
      @@last_message = message
    end
    
    protected
    
    def self.create_from_response(response)
      if response.is_a?(Array)
        list = []
        response.each do |element|
          list << self.new(element)
        end
        return list
      else
        self.new(response)
      end
    end
    
    def self.create_collection_from_response(response)
      return Collection.new(create_from_response(response['elements']), response['count'], response['page'])
    end
    
    private
    
    def self.get(path, params = {})
      add_nonce(params)
      handle_response do
        http.get do |request|
          request.url path, params
          request.headers['Accept'] = 'application/json'
          request.headers['Authorization'] = auth_header('get', path, params)
        end
      end
    end
    
    def self.post(path, params = {})
      add_nonce(params)
      handle_response do
        http.post do |request|
          request.url path, params
          request.headers['Accept'] = 'application/json'
          request.headers['Authorization'] = auth_header('post', path, params)
        end
      end
    end

    def self.put(path, params = {})
      add_nonce(params)
      handle_response do
        http.put do |request|
          request.url path, params
          request.headers['Accept'] = 'application/json'
          request.headers['Authorization'] = auth_header('put', path, params)
        end
      end
    end
    
    def self.delete(path, params = {})
      add_nonce(params)
      handle_response do
        http.delete do |request|
          request.url path, params
          request.headers['Accept'] = 'application/json'
          request.headers['Authorization'] = auth_header('delete', path, params)
        end
      end
    end
    
    def self.add_nonce(params)
      params.merge!({'nonce' => nonce})
    end
    
    def self.auth_header(method, path, params = {})
      Lobbyist::BasicAuth.header(method, params, { api_key: Lobbyist.api_key, api_secret: Lobbyist.api_secret})
    end

    def self.http
      Lobbyist.http
    end

    def self.handle_response
      response = yield
      case response.status
      when 400
        raise Lobbyist::Error::BadRequest.new(response.body)
      when 401
        raise Lobbyist::Error::Unauthorized.new(response.body, last_message)
      when 403
        raise Lobbyist::Error::Forbidden.new(response.body)
      when 404
        raise Lobbyist::Error::NotFound.new(response.body)
      when 412
        raise Lobbyist::Error::PreconditionFailed.new(response.body)
      when 422
        raise Lobbyist::Error::UnprocessableEntity.new(response.body)
      else
        response = MultiJson.load(response.body)
        return response
      end
    rescue MultiJson::DecodeError
      raise Lobbyist::Error::DecodeError.new "Unparsable Response: #{response.body}"
    end

    private

    # Create the getter and setter for the attribute named 'name'. If reference is true
    # create the alternate version of the setter.
    def define_attribute(name, reference = false)
      self.class_eval("def #{name};@#{name};end")
      if reference
        self.class_eval("def #{name}=(val);@#{name}=Lobbyist::#{name.camelize}.new(val);end")
      else
        self.class_eval("def #{name}=(val);@#{name}=val;end")
      end
    end
    
  end
end