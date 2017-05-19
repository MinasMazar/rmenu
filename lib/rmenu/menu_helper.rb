
module Rmenu
  module MenuHelper
    def evaluated_menu(_menu)
      _menu.map do |h|
        if h.is_a? Hash
          h.merge({
            label: eval_block(h[:label]),
            cmd: h[:cmd]
          })
        else
          {
            label:  eval_block(h),
            cmd: h
          }
        end
      end
    end

    def insert_separator(_menu)
      _menu.unshift separator
    end

    def separator
      if defined? context
        {
          label: "#{ separator_char * separator_count }",
          cmd: ''
        }
      end
    end

    private

    def separator_char
      context[:separator_char] || " "
    end

    def separator_count
      180
    end
  end
end
