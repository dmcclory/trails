module Trails
  module ResponseAttrs

    attr_writer :status
    attr_accessor :body

    def status
      @status ||= 200
    end

    def headers
      @reponse ||= {}
    end

    def body
      @body ||= ""
    end

  end
end
