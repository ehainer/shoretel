require 'net/https'
require 'uri'

module Shoretel
  class Request

    attr_reader :did, :pin

    def initialize(did, pin)
      @did = did
      @pin = pin
    end

    def dial(number, endpoint=nil)
      execute! ::Shoretel::Command::Dial.new(did, pin, number, endpoint)
    end

    def answer(call_id=nil, endpoint=nil)
      execute! ::Shoretel::Command::Answer.new(did, pin, call_id, endpoint)
    end

    def ignore(call_id=nil)
      execute! ::Shoretel::Command::Ignore.new(did, pin, call_id)
    end

    def release(call_id=nil)
      execute! ::Shoretel::Command::Release.new(did, pin, call_id)
    end

    def hold(call_id=nil)
      execute! ::Shoretel::Command::Hold.new(did, pin, call_id)
    end

    def resume(call_id=nil)
      execute! ::Shoretel::Command::Resume.new(did, pin, call_id)
    end

    def list(endpoint=nil)
      execute! ::Shoretel::Command::List.new(did, pin, endpoint)
    end

    def subscribe
      execute! ::Shoretel::Command::Subscribe.new(did, pin)
    end

    alias_method :hangup, :release

    private

      def execute!(command)
        request = Net::HTTP::Post.new uri.request_uri, { 'Transfer-Encoding' => 'chunked', 'Content-Type' => 'text/plain', 'Connection' => 'keep-alive' }
        request.body = command.to_xml
        response = connection.request(request)
        # For debugging purposes, output the outgoing xml and returned xml
        #puts command.to_xml.light_cyan
        #puts response.body.light_yellow
        ::Shoretel::Response.new(response, command)
      end

      def connection
        @connection ||= begin
          conn = Net::HTTP.new(uri.host, uri.port)
          if uri.scheme == 'https'
            conn.use_ssl = true
            conn.verify_mode = OpenSSL::SSL::VERIFY_NONE
          end
          conn
        end
      end

      def uri
        URI.parse(Shoretel.config.endpoint)
      end

  end
end
