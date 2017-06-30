require 'colorize'
require 'nokogiri'
require 'shoretel/version'
require 'shoretel/config'
require 'shoretel/request'
require 'shoretel/response'
require 'shoretel/response/error'
require 'shoretel/command'
require 'shoretel/command/base'
require 'shoretel/command/dial'
require 'shoretel/command/answer'
require 'shoretel/command/ignore'
require 'shoretel/command/release'
require 'shoretel/command/hold'
require 'shoretel/command/resume'
require 'shoretel/command/list'
require 'shoretel/command/subscribe'

module Shoretel

  def self.setup
    yield config
  end

  def self.config
    @config ||= Config.new
  end

  def self.with_user(did, pin)
    yield request(did, pin)
  end

  def self.dial(did, pin, number, endpoint=nil)
    request(did, pin).dial(number, endpoint)
  end

  def self.answer(did, pin, call_id=nil, endpoint=nil)
    request(did, pin).answer(call_id, endpoint)
  end

  def self.ignore(did, pin, call_id=nil)
    request(did, pin).ignore(call_id)
  end

  def self.release(did, pin, call_id=nil)
    request(did, pin).release(call_id)
  end

  def self.hold(did, pin, call_id=nil)
    request(did, pin).hold(call_id)
  end

  def self.resume(did, pin, call_id=nil)
    request(did, pin).resume(call_id)
  end

  def self.list(did, pin, endpoint=nil)
    request(did, pin).list(endpoint)
  end

  def self.subscribe(did, pin)
    request(did, pin).subscribe
  end

  private

    def self.request(did, pin)
      Request.new(did, pin)
    end

end

require 'shoretel/engine' if defined?(Rails)