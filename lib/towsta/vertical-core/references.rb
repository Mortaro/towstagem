module Towsta

  class VerticalCore

    class << self
      attr_accessor :all, :count
    end

    self.all ||= []

    def self.first
      self.all.first
    end

    def self.last
      self.all.last
    end

    def self.find id
      self.find_by_id id
    end

    def self.random
      position = (self.all.size) - 1
      self.all[rand(position)]
    end

    def self.find_by attr, value
      self.all.each { |horizontal| return horizontal if horizontal.send(:"object_of_#{attr}").compare value }
    end

    def self.find_all_by attr, value
      self.all.select { |horizontal| horizontal.send(:"object_of_#{attr}").compare value }
    end

    def self.method_missing m, *args, &block
      return self.find_by Regexp.last_match(1), args.first if m =~ /find_by_(.+)/
      return self.find_all_by Regexp.last_match(1), args.first if m =~ /find_all_by_(.+)/
      super
    end

  end

end
