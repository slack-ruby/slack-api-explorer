require 'spec_helper'

describe Shellwords do
  context '#parse' do
    it 'splits a command line' do
      command, pipe = Shellwords.parse('hello world')
      expect(command).to eq(%w(hello world))
      expect(pipe).to be nil
    end
    it 'splits a command line with pipe' do
      command, pipe = Shellwords.parse('hello world|echo')
      expect(command).to eq(%w(hello world))
      expect(pipe).to eq('echo')
    end
    it 'splits a command line with pipe punctuation' do
      command, pipe = Shellwords.parse('hello world|$..foo')
      expect(command).to eq(%w(hello world))
      expect(pipe).to eq('$..foo')
    end
    it 'splits a command line with pipe with spaces' do
      command, pipe = Shellwords.parse('hello world | echo foo bar')
      expect(command).to eq(%w(hello world))
      expect(pipe).to eq('echo foo bar')
    end
  end
end
