module Shoretel
  module Command
    class Base

      attr_accessor :did, :pin, :args

      def initialize(did, pin, *args)
        @did = did
        @pin = pin
        @args = args.flatten
      end

      def to_xml
        dec = Nokogiri::XML('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>')
        builder = Nokogiri::XML::Builder.with(dec) do
          Command do
            Name command_name
            User did
            Password pin
          end
        end

        args.each do |arg|
          argument = Nokogiri::XML::Node.new('Arguments', dec)
          argument['xsi:type'] = 'ns3:string'
          argument['xmlns:ns3'] = 'http://www.w3.org/2001/XMLSchema'
          argument['xmlns:xsi'] = 'http://www.w3.org/2001/XMLSchema-instance'
          argument.content = arg
          builder.doc.root << argument
        end

        builder.to_xml
      end

      def command_name
        [Shoretel.config.namespace_prefix.gsub(/^\.+|\.+$/, ''), name].join('.')
      end

    end
  end
end