require 'spec_helper'

describe Trails::Controller do

  let(:subclass) { Class.new(described_class) do
      def read(*)
        render text: "Success"
      end

      def index(*)
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

  describe "#rack_app" do
    let(:action_name)   { :read }
    let (:action)       { subject.rack_app(action_name) }

    it "returns a Rack app for a controller action" do
      expect(action).to respond_to(:call)
    end

    describe "the Rack app" do
      it "returns a status-header-body triple" do
        expect(action.call({})).to eq(response)
      end

      context "controller action does not call render" do
        let(:resource_name) { "foos" }
        let(:action_name)   { :index }

        before do
          allow(subject).to receive(:resource_name) { resource_name }
        end

        it "renders the teplate registered for the resource name & action" do
          expect(controller).to receive(:render).with( template: "#{resource_name}##{action_name}")
          action.call({})
          expect(controller.headers['Content-Type']).to eq 'text/html'
        end

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

  describe "#params" do
    context "in a controller action" do
      let(:subclass) { Class.new(described_class) do
          def read
            render text: params[:awesome]
          end
        end
      }
      let(:env) { { :awesome => "You betcha!" } }
      before do
      end
      it "makes the env available as a hash with indifferent access" do
        response = subject.rack_app(:read).call(env)
        expect(response.last).to eq ["You betcha!"]
      end
    end
  end
end
