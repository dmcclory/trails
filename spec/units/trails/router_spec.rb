require 'spec_helper'

describe Trails::Router do

  let!(:foo_controller_class) { class_double("FoosController",
                                           new: foo_controller).as_stubbed_const }
  let(:env) { { "PATH_INFO" => "/foos" , "REQUEST_METHOD" => "GET"} }
  let(:endpoint) { double( call: [200, {}, ['Success!'] ] ) }
  let(:foo_controller) {
    instance_double("FoosController",
                    resource_name: "foos",
                    action_for: endpoint
                   )
  }
  let(:missing_resource_controller) { double }

  context "when defining the routes" do
    describe "#resources" do
      context "when given a plural resource name" do
        it "adds a new resource controller to the router's list of controller" do
          subject.resources :foos
          expect(subject.controllers).to include(foo_controller)
        end
      end

      context "when given a custom member method" do
        before do
          allow(foo_controller).to receive(:build_app_for)
        end
        it "adds a custom member-level route to the controller" do
          subject.resources :foos do
            member do
              put :put_a_bird_on_it
            end
          end
          expect(foo_controller).to have_received(:build_app_for).with(:put_a_bird_on_it)
        end
        it "adds a custom collection-level route to the controller" do
          subject.resources :foos do
            collection do
              get :special_report
            end
          end
          expect(foo_controller).to have_received(:build_app_for).with(:special_report)
        end
      end
    end
  end

  context "when dispatching requests to controllers" do
    before do
      subject.controllers = [foo_controller]
      subject.missing_resource_controller = missing_resource_controller
    end

    describe "#call" do
      context "route matches Controller & action for an endpoint" do
        it "calls the endpoint" do
           subject.call(env)
           expect(endpoint).to have_received(:call)
        end
      end
    end

    describe "#controller_for" do
      context "route's first segment matches a controller's class name" do
        let(:route) { "/foos" }
        it "returns the FoosController" do
          expect(subject.controller_for(route)).to eq foo_controller
        end
      end

      context "no controller's class name matches the first URL segment" do
        let(:route) { "/bar" }
        it "returns a MissingResourceController" do
          expect(subject.controller_for(route)).to eq missing_resource_controller
        end
      end
    end
  end

  describe "#action_for" do
    let(:router) { described_class.new }

    subject { router.action_for(request, method) }

    context "route matches :index action" do
      let(:request) { "" }
      let(:method) { "GET" }
      it { should == :index }
    end

    context "route matches :new action" do
      let(:request) { "/new" }
      let(:method) { "GET" }
      it { should == :new }
    end

    context "route matches :create action" do
      let(:request) { "" }
      let(:method) { "POST" }
      it { should == :create }
    end

    context "route matches :show action" do
      let(:request) { "/123" }
      let(:method) { "GET" }
      it { should == :show }
    end

    context "route matches :edit action" do
      let(:request) { "/123/edit" }
      let(:method) { "GET" }
      it { should == :edit }
    end

    context "route matches :update action" do
      let(:request) { "/123" }
      let(:method) { "PUT" }
      it { should == :update }
    end

    context "route matches :destroy action" do
      let(:request) { "/123" }
      let(:method) { "DELETE" }
      it { should == :destroy }
      it "this doesn't make sense" do
        expect(router.controllers.length).to eq 0
      end
    end

    context "route matches a custom member action" do
      let(:request) { "/123/put_a_bird_on_it" }
      let(:method)  { "PUT" }

      before do
        allow(foo_controller).to receive(:build_app_for)
        router.resources :foos do
          member do
            put :put_a_bird_on_it
          end
        end
      end
      it { should == :put_a_bird_on_it }

    end
  end
end
