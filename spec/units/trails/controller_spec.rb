require 'spec_helper'

describe Trails::Controller do

  let(:app) { lambda { [200, {}, ["Hello world!"] ] } }
  let(:action) { :read }


  describe "#action_for" do
    before do
      subject.actions[action] = app
    end
    it "retuns a Rack app" do
      expect(subject.action_for(action)).to eq(app)
    end
  end

  describe "#initialize" do

    let(:subclass) { Class.new(described_class) }

    before do
      subclass.send(:define_method, :method) do
        render "Success"
      end
    end

    let(:controller) { subclass.new }
    subject { controller.action_for :method }

    it "creates an action for each instance method" do
      expect(subject).to respond_to(:call)
    end
  end
end
