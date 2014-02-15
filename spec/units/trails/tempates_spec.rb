require 'spec_helper'

describe Trails::Templates do
  describe ".register_template" do
    let(:name)     { "foos#index" }
    let(:template) { "hello <%= @world %>" }

    subject { described_class }

    it "stores a key/template pair" do
      subject.register(name, template)
      expect(subject.fetch(name)).to eq template
    end
  end
end
