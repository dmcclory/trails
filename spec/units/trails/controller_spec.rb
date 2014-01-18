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

  describe "#resource_name" do
    let(:foos_controller_class) {
      stub_const("FoosController", Class.new(described_class ))
    }
    subject { foos_controller_class.new }

    it "returns the downcased & snake-cased name of the class, minus 'controller'" do
      expect(subject.resource_name).to eq "foos"
    end
  end
end
