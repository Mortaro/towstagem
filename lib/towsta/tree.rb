module Towsta

 class Tree

    attr_accessor :item, :left, :right

    def initialize element
      @item = element
    end

    def add element
      item.id > element.id ? ( @right ? @right.add(element) : add_right(Tree.new(element))) : (@left ? @left.add(element): add_left(Tree.new(element)))
    end

    def add_left tree
      @left = tree
    end

    def add_right tree
      @right = tree
    end

    def find id
      return self.item if @item.id == id
      return @right.find id if @right && @item.id > id
      return @left.find id if @left
    end

  end

end
