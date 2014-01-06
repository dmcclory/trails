require 'spec_helper'

describe Trails::Router do

  let(:foo_controller_class) { double name: :FooController }
  let(:env) { { "PATH_INFO" => "/foo" , "METHOD" => "GET"} }
  let(:endpoint) { double( call: [200, {}, ['Success!'] ] ) }
  let(:foo_controller) {
    double( action: endpoint, class: foo_controller_class )
  }
  let(:missing_resource_controller) { double }

  describe "#call" do
    context "route matches Controller & action for an endpoint" do
      before do
        subject.controllers = [foo_controller]
      end
      it "calls the endpoint" do
         subject.call(env)
         expect(endpoint).to have_received(:call)
      end
    end
  end

  describe "#controller_for" do
    before do
      stub_const("FooController", foo_controller_class)
      subject.controllers = [foo_controller]
      subject.missing_resource_controller = missing_resource_controller
    end

    context "route's first segment matches a controller's class name" do
      let(:route) { "/foo" }
      it "returns the FooController" do
        expect(subject.controller_for(route)).to eq foo_controller
      end
    end

    context "no controller's class name matches the first URL segment" do
      let(:route) { "/bar" }
      before do
      end
      it "returns a MissingResourceController" do
        expect(subject.controller_for(route)).to eq missing_resource_controller
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
    end
  end
end
