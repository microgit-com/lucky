# This class returns a param objects based on the content type
module Lucky
  module Params
    struct Factory
      @request : HTTP::Request
      @route_params : Hash(String, String)

      def initialize(@request, @route_params = {} of String => String)
      end

      # Create a new params object
      #
      # The params object is initialized with an `HTTP::Request` and a hash of
      # params. The request object has many optional parameters. See Crystal's
      # [HTTP::Request](https://crystal-lang.org/api/latest/HTTP/Request.html)
      # class for more details.
      #
      # ```crystal
      # request = HTTP::Request.new("GET", "/")
      # route_params = {"token" => "123"}
      #
      # Lucky::Params.new(request, route_params)
      # ```
      def call : Lucky::Params::Base
        paramable =
          if json?
            JsonParams
          elsif multipart?
            MultipartFormParams
          else
            UrlEncodedFormParams
          end

        paramable.new(@request, @route_params)
      end

      private def json? : Bool
        content_type.try(&.match(/^application\/json/))
      end

      private def multipart? : Bool
        content_type.try(&.match(/^multipart\/form-data/))
      end
    end
  end
end
