module Towsta
  module Kinds

    class VideoKind < MainKind

      def set content
        return @content = content if content.class == Cameraman::VideoReference
        begin
          @content = Cameraman::VideoReference.new JSON.parse(content, :symbolize_names => true)
        rescue
          @content = nil
        end
      end

      def compare object
        @content.to_s == object.to_s
      end

    end

  end
end
