require 'spec_helper'

describe Shellwords do
  describe '#parse' do
    it 'splits a command line' do
      command, pipe = described_class.parse('hello world')
      expect(command).to eq(%w(hello world))
      expect(pipe).to be_nil
    end

    it 'splits a command line with pipe' do
      command, pipe = described_class.parse('hello world|echo')
      expect(command).to eq(%w(hello world))
      expect(pipe).to eq('echo')
    end

    it 'splits a command line with pipe punctuation' do
      command, pipe = described_class.parse('hello world|$..foo')
      expect(command).to eq(%w(hello world))
      expect(pipe).to eq('$..foo')
    end

    it 'splits a command line with pipe with spaces' do
      command, pipe = described_class.parse('hello world | echo foo bar')
      expect(command).to eq(%w(hello world))
      expect(pipe).to eq('echo foo bar')
    end
  end
end
