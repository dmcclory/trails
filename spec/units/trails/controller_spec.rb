require 'spec_helper'

describe Trails::Controller do

  let(:subclass) { Class.new(described_class) do
      def read(*)
        render text: "Success"
      end
    end
  }

  let(:response) { [200, {}, ["Success"] ] }
  let(:controller) { subclass.new }

  subject { controller }

  describe "#initialize" do
    it "creates an action for each instance method" do
      expect(subject.actions.keys).to include(:read)
    end
  end

  describe "#action_for" do
    let (:action) { subject.action_for(:read) }
    it "returns a Rack app for a controller action" do
      expect(action).to respond_to(:call)
    end
    describe "the Rack app" do
      it "returns a status-header-body triple" do
        expect(action.call({})).to eq(response)
      end
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
