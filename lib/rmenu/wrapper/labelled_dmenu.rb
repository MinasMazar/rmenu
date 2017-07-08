
module Rmenu
  module Wrapper
    class LabelledDmenu < Dmenu
      def labelled_items
        @items.select { |h| h.is_a? Hash }
      end

      def items
        @items.map { |h| h.is_a?(Hash) ? h[:label] : h.to_s }
      end

      def run
        item = super
        labelled_item = labelled_items.find { |i| i[:label] == item }
        labelled_item || { label: item, cmd: item }
      end
      alias :gets :run
    end
  end
end
