module Towsta

  class Vertical

    class << self
      attr_accessor :all
    end

    def self.create(args)
      klass = Class.new do

        class << self
          attr_accessor :all, :attributes, :count
        end

        attr_accessor :response

        args[:slices].each do |attr, kind|
          eval "def object_of_#{attr}; @#{attr}; end;"
          eval "def #{attr}= value; @#{attr} ||= Towsta::Kinds::#{kind[0].upcase + kind[1..-1]}Kind.new; @#{attr}.set value; end;"
          eval "def #{attr}; @#{attr}.get; end;"
          eval "def self.find_by_#{attr} value; self.all.each {|e| return e if e.object_of_#{attr}.compare value}; nil; end;"
          eval "def self.find_all_by_#{attr} value; found =[]; self.all.each {|e| found << e if e.object_of_#{attr}.compare value}; found; end;"
          eval "def option_for_#{attr} value; return {value: value, selected: 'selected'} if value == #{attr}; {value: value}; end"
        end

        def self.first
          self.all.first
        end

        def self.last
          self.all.last
        end

        def self.find id
          self.find_by_id id
        end

        def initialize args
          self.attributes.merge(args).each {|k,v| eval "self.#{k}= '#{v}';"}
          self.class.all << self
        end

        def update args, author=$towsta_default_author
          args.each {|k,v| eval "self.#{k}= '#{v}';"}
          self.save author
        end

        def destroy
        #  self.class.all.delete self
        #  self
        end

        def self.to_hash
          hashes = []
          self.all.each {|hash| hashes << hash.attributes}
          hashes
        end

        def save creator=$towsta_default_author
          creator = author.email if author
          export = self.attributes
          export.delete :author
          export.delete :created_at
          export.delete :updated_at
          id_aux = export.delete(:id)
          id_aux ? id_aux : '0'
          export = {:creator => creator, :vertical => self.class.to_s, :attributes => export, :id => id_aux}
          response = Towsta::Synchronizer.save_request export
          @response = response
          self.id = response[:id] if response[:status]
          self.author = User.find_by_email creator
          Towsta::Memory.flush if $towsta_cache
          response[:status]
        end

        def self.random
          position = (self.all.size) - 1
          self.all[rand(position)]
        end

        def self.create args, creator=$towsta_default_author
          new = self.new(args.merge(:id => nil))
          new.save creator
          new
        end

        def attributes
          horizontal = {}
          self.class.attributes.each do |attr|
            slice = eval("self.object_of_#{attr.to_s}")
            horizontal[attr] = slice ? slice.export : nil
          end
          horizontal
        end

        def self.add_occurrence occurrence
          self.send(:define_singleton_method, "occurrences_of_#{occurrence[:name].downcase}") do
            eval occurrence[:items].inspect
          end
        end

      end
      klass.all = []
      klass.count = args[:count]
      klass.attributes = args[:slices].keys
      Object.const_set args[:name], klass
    end

  end

end
