module Towsta
  module Kinds

    class MoneyKind < MainKind

      def set content
        content = content.gsub('.','').gsub(',','.') if content.class == String
        @content = content.to_f
      end

      def compare object
        @content == object.to_f
      end

    end

  end
end
