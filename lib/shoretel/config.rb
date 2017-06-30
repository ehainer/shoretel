module Shoretel
  class Config

    attr_accessor :namespace_prefix, :endpoint

    def initialize
      @namespace_prefix ||= 'org.m5.apps.v1.cti.ClickToDial'
      @endpoint ||= 'https://hostedconnect.m5net.com/bobl/bobl'
    end

  end
end
