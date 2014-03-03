require 'faraday_middleware/response_middleware'
require 'faraday_middleware/request/encode_json'

module FaradayMiddleware
  module MultiJson
    class ParseJson < FaradayMiddleware::ResponseMiddleware
      dependency 'multi_json'

      def parse(body)
        return "" if body.strip.empty?
        ::MultiJson.load(body, @options)
      rescue => exception
        raise Faraday::Error::ParsingError.new(exception, body)
      end
    end

    class EncodeJson < FaradayMiddleware::EncodeJson
      dependency 'multi_json'

      def initialize(app, *)
        super(app)
      end

      def encode(data)
        ::MultiJson.dump data
      end
    end
  end
end

Faraday.register_middleware :response, :multi_json => FaradayMiddleware::MultiJson::ParseJson
Faraday.register_middleware :request, :multi_json => FaradayMiddleware::MultiJson::EncodeJson
