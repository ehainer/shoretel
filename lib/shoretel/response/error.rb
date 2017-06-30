module Shoretel
  class Response
    class Error

      attr_accessor :message

      def initialize(msg, major, minor)
        @message = msg
        @major = major
        @minor = minor
      end

      def major_code
        @major.to_i
      end

      def minor_code
        @minor.to_i
      end

      def code
        "#{@major}.#{@minor}".to_f
      end

    end
  end
end