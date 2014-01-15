require 'spec_helper'

describe Trails::ResponseAttrs do

  let(:controller_class) { Class.new { include Trails::ResponseAttrs } }

  subject { controller_class.new }

  describe "module adds attrs for status" do
    it "blah" do
      subject.status = 401
      expect(subject.status).to equal 401
    end
    context "no value given" do
      it "defaults to 200" do
        expect(subject.status).to equal 200
      end
    end
  end

  describe "module adds attrs for headers" do
    it "blah" do
      subject.headers["Content-Type"] = "application/json"
      expect(subject.headers["Content-Type"]).to eq "application/json"
    end

  end

  describe "module adds attrs for body" do
    it "blah" do
      subject.body = "9000"
      expect(subject.body).to eq "9000"
    end

    context "no value given" do
      it "defaults to empty-string" do
        expect(subject.body).to eq ""
      end
    end
  end
end
