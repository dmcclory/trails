require 'spec_helper'

describe Trails::Renderer do

  subject { Class.new }

  describe "#included preconditions" do
    before do
      subject.send(:define_method, :status) { nil }
      subject.send(:define_method, :headers) { nil }
      subject.send(:define_method, :body) { nil }
    end

    context "including class defines: #status, #headers, and #body" do
      it "will not raise an error" do
        expect {subject.send :include, Trails::Renderer}.not_to raise_error
      end
    end

    context "status is not defined on the including class" do
      before do
        subject.send(:undef_method, :status) { nil }
      end
      it "will raise an error" do
        expect { subject.send :include, Trails::Renderer}.to raise_error
      end
    end

    context "headers is not defined on the including class" do
      before do
        subject.send(:undef_method, :headers) { nil }
      end
      it "will raise an error" do
        expect { subject.send :include, Trails::Renderer}.to raise_error
      end
    end

    context "body is not defined on the including class" do
      before do
        subject.send(:undef_method, :body) { nil }
      end
      it "will raise an error" do
        expect {subject.send :include, Trails::Renderer}.to raise_error
      end
    end
  end

  describe "#render" do

    let(:controller_class) {
      Class.new do
        attr_accessor :status,:headers, :body
        include Trails::Renderer
      end
    }
    subject { controller_class.new }

    context "given text" do
      before do
        subject.render text: "Hello World!"
      end
      it "sets the body to the text, wrapped in an array" do
        expect(subject.body).to eq ["Hello World!"]
      end
    end

    context "given json" do
      before do
        subject.headers = {}
        subject.render json: [1, 2, 3]
      end
      it "sets the Content-type header to json" do
        expect(subject.headers['Content-Type']).to eq 'application/json'
      end
    end
  end
end
