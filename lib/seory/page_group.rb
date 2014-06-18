module Seory
  class PageGroup
    attr_accessor :default
    attr_reader   :name, :pages

    def initialize(name)
      @name  = name
      @pages = []
    end

    def add(page)
      @pages << page
    end
  end
end
