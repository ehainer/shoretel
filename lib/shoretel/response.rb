module Shoretel
  class Response

    attr_accessor :response, :command

    def initialize(response, command)
      @response = response
      @command = command
    end

    def id
      xml.root.at(:Id).try(:text).to_i
    end

    def error?
      error_count > 0
    end

    def error_count
      xml.root.at(:ErrorCount).try(:text).to_i
    end

    def errors
      xml.root.xpath('Errors/item').map do |item|
        major = item.at(:MajorErrorCode).text
        minor = item.at(:MinorErrorCode).text
        message = item.at(:Message).text
        Error.new(message, major, minor)
      end
    end

    def xml
      @xml ||= Nokogiri::XML(response.body)
    end

    alias_method :errors?, :error?

  end
end
