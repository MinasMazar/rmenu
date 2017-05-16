
module Rmenu
  module Wrapper
    class LabelledDmenu < Dmenu
      def labelled_items
        @items.select { |h| h.is_a? Hash }
      end

      def items
        @items.map { |h| h[:label] }
      end

      def run
        item = super
        labelled_item = labelled_items.find { |i| (i.is_a?(Hash) ? i[:label] : nil ) == item }
        labelled_item || { label: item, cmd: item }
      end
      alias :gets :run
    end
  end
end