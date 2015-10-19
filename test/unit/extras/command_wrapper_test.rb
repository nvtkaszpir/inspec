# encoding: utf-8
require 'helper'
require 'train/transports/mock'
require 'train/extras'
require 'base64'

describe 'linux command' do
  let(:cls) { Train::Extras::LinuxCommand }
  let(:cmd) { rand.to_s }
  let(:backend) {
    backend = Train::Transports::Mock.new.connection
    backend.mock_os({ family: 'linux' })
    backend
  }

  it 'wraps commands in sudo' do
    lc = cls.new(backend, { sudo: true })
    lc.run(cmd).must_equal "sudo #{cmd}"
  end

  it 'wraps commands in sudo with all options' do
    opts = rand.to_s
    lc = cls.new(backend, { sudo: true, sudo_options: opts })
    lc.run(cmd).must_equal "sudo #{opts} #{cmd}"
  end

  it 'runs commands in sudo with password' do
    pw = rand.to_s
    lc = cls.new(backend, { sudo: true, sudo_password: pw })
    bpw = Base64.strict_encode64(pw)
    lc.run(cmd).must_equal "echo #{bpw} | base64 -d | sudo #{cmd}"
  end
end
