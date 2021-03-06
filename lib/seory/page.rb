require 'seory'
require 'seory/condition'

module Seory
  class EmptyCondition < ::Seory::Error; end
  class AccessorNameTaken < ::Seory::Error; end

  class Page

    attr_reader :assign_name_accessors

    def initialize(*conditions, &block)
      @conditions  =
        if block_given?
          [Condition::Block.new(block)]
        elsif conditions.first == :default
          :default
        else
          conditions.map {|condition| Seory::Condition[condition] }
        end

      raise EmptyCondition if @conditions.blank?

      @contents, @assign_name_accessors = {}, []
    end

    def define(name, value = nil, &block)
      @contents[name] = block_given? ? block : value
    end

    def assign_reader(*assign_names)
      if (taken = Seory::CONTENTS & assign_names).size > 0
        raise AccessorNameTaken, taken.join(', ')
      end

      assign_name_accessors.concat(assign_names)
    end

    def content_for(name)
      @contents[name]
    end

    def match?(controller)
      return true if default?

      @conditions.any? {|condition| condition.match?(controller) }
    end

    def default?
      @conditions == :default
    end
  end
end
