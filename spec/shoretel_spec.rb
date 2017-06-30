require 'spec_helper'

describe Shoretel do

  let(:did) { '1234567890' }
  let(:pin) { '12345' }

  before(:each) do
    stub_request(:post, Shoretel.config.endpoint).to_return(status: 200, body: '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><org.m5.api.v1.Response xmlns:m5="http://www.m5net.com/org/m5/data/v2/cti" xmlns:csta="http://www.ecma-international.org/standards/ecma-323/csta/ed5"><ErrorCount>1</ErrorCount><Errors><item xsi:type="org.m5.api.v1.Error" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><MajorErrorCode>5</MajorErrorCode><Message>Authorization or authentication failed</Message><MinorErrorCode>0</MinorErrorCode></item></Errors><Id>1033010</Id></org.m5.api.v1.Response>')
  end

  it 'has a version number' do
    expect(Shoretel::VERSION).not_to be nil
  end

  it 'yields the configuration' do
    expect { |b| Shoretel.setup(&b) }.to yield_with_args(Shoretel.config)
  end

  it 'has access to the configuration' do
    expect(Shoretel.config).to be_a(Shoretel::Config)
  end

  it 'can perform any call action with a defined user did/pin' do
    expect { |b| Shoretel.with_user(did, pin, &b) }.to yield_with_args(Shoretel::Request)
  end

  context 'Calls' do

    it 'can be dialed' do
      expect(Shoretel.dial(did, pin, 1234567890)).to be_a(Shoretel::Response)
    end

    it 'can be answered' do
      expect(Shoretel.answer(did, pin)).to be_a(Shoretel::Response)
    end

    it 'can be ignored' do
      expect(Shoretel.ignore(did, pin)).to be_a(Shoretel::Response)
    end

    it 'can be released/hung up' do
      expect(Shoretel.release(did, pin)).to be_a(Shoretel::Response)
    end

    it 'can be held' do
      expect(Shoretel.hold(did, pin)).to be_a(Shoretel::Response)
    end

    it 'can be resumed' do
      expect(Shoretel.resume(did, pin)).to be_a(Shoretel::Response)
    end

    it 'can be listed' do
      expect(Shoretel.list(did, pin)).to be_a(Shoretel::Response)
    end

    it 'can start a subscription for call events' do
      expect(Shoretel.subscribe(did, pin)).to be_a(Shoretel::Response)
    end

  end

  context 'Responses' do

    it 'will have errors if the did/pin is invalid' do
      response = Shoretel.dial('TEST', 'TEST', 1234567890)
      expect(response.error?).to eq(true)
      expect(response.error_count).to be >= 1
      expect(response.errors).to all(be_a(Shoretel::Response::Error))
    end

    it 'will have a numeric call id' do
      response = Shoretel.dial('TEST', 'TEST', 1234567890)
      expect(response.id).to be_a(Numeric)
      expect(response.id).to be > 0
    end

  end

  context 'Errors' do

    it 'will have a major and minor error code' do
      response = Shoretel.dial('TEST', 'TEST', 1234567890)
      error = response.errors.first

      expect(error.major_code).to be_a(Numeric)
      expect(error.major_code).to be >= 0

      expect(error.minor_code).to be_a(Numeric)
      expect(error.minor_code).to be >= 0

      expect(error.code).to be_a(Float)
      expect(error.code).to eq("#{error.major_code}.#{error.minor_code}".to_f)
    end

  end

end
