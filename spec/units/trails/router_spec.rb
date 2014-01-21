require 'spec_helper'

describe Trails::Router do

  let!(:foo_controller_class) {
    class_double("FoosController",
                 new: foo_controller,
                 resource_name: "foos").as_stubbed_const
  }
  let(:env) { { "PATH_INFO" => "/foos" , "REQUEST_METHOD" => "GET"} }
  let(:endpoint) { double( call: [200, {}, ['Success!'] ] ) }
  let(:foo_controller) {
    instance_double("FoosController",
                    resource_name: "foos",
                    rack_app: endpoint
                   )
  }
  let(:missing_resource_controller_class) {
    class_double("MissingResourceController",
                 new: missing_resource_controller,
                 resource_name: "missing_resource").as_stubbed_const
  }
  let(:missing_resource_controller) { double }

  context "when defining the routes" do
    describe "#resources" do
      context "when given a plural resource name" do
        it "adds a new resource controller to the router's list of controller" do
          subject.resources :foos
          expect(subject.controller_classes).to include(foo_controller_class)
        end
      end
    end
  end

  context "when dispatching requests to controllers" do
    before do
      subject.controller_classes = [foo_controller_class]
      subject.missing_resource_controller_class = missing_resource_controller_class
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
        expect(router.controller_classes.length).to eq 0
      end
    end

    context "route matches a custom member action" do
      before do
        router.resources :foos do
          member do
            put :put_a_bird_on_it
            get :special_info
            post :dont_do_that
            delete :special_field
            patch :update_part
          end
        end
      end

      context "custom put requests" do
        let(:request) { "/123/put_a_bird_on_it" }
        let(:method)  { "PUT" }
        it { should == :put_a_bird_on_it }
      end

      context "custom get requests" do
        let(:request) { "/123/special_info" }
        let(:method)  { "GET" }
        it { should == :special_info }
      end

      context "custom post requests" do
        let(:request) { "/123/dont_do_that" }
        let(:method)  { "POST" }
        it { should == :dont_do_that }
      end

      context "custom delete requests" do
        let(:request) { "/123/special_field" }
        let(:method)  { "DELETE" }
        it { should == :special_field }
      end

      context "custom patch requests" do
        let(:request) { "/123/update_part" }
        let(:method)  { "PATCH" }
        it { should == :update_part }
      end
    end
  end
end
