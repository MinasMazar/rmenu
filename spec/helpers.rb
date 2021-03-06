
module Rmenu
  module Test
    module Helpers
      def self.sh(cmd)
        stdin_stream, stdout_stream, stderr_stream, wait_thr = Open3.popen3(cmd)
        stdout = stdout_stream.gets(nil) || ""
        stderr = stderr_stream.gets(nil) || ""
        stdout_stream.close
        stderr_stream.gets(nil)
        stderr_stream.close
        stdin_stream.close
        exit_code = wait_thr.value
        yield exit_code, stdout, stderr if block_given?
        { status: exit_code.exitstatus, output: stdout + stderr }
      end
      def sh(cmd)
        Helpers.sh cmd
      end
      def tmp_dir
        RSpec.configuration.tmp_dir
      end
      def create_tmp_dir
        FileUtils.mkpath tmp_dir unless File.exist? tmp_dir
      end
      def remote_tmp_dir
        FileUtils.rm_rf tmp_dir if File.exist? tmp_dir
      end
      def create_history_file
        create_tmp_dir
        File.write(RSpec.configuration.history_file, history_file_content)
      end
      def remove_history_file
        FileUtils.rm_rf RSpec.configuration.history_file
      end
      def history_file_content
        <<-EOS
---
:history:
  - item1
  - item2
        EOS
      end
      def menu_with_progressive_pick_counter
        [
          {
            label: 'Mozilla Firefox',
            cmd: 'firefox',
            picked: 1
          },
          {
            label: 'Opera browser',
            cmd: 'opera',
            picked: 2
          },
          {
            label: 'Luakit browser',
            cmd: 'luakit',
            picked: 3
          }
        ]
      end
      def menu_with_reverse_pick_counter
        [
          {
            label: 'Mozilla Firefox',
            cmd: 'firefox',
            picked: 3
          },
          {
            label: 'Opera browser',
            cmd: 'opera',
            picked: 2
          },
          {
            label: 'Luakit browser',
            cmd: 'luakit',
            picked: 1
          }
        ]
      end
      def menu_with_zero_pick_counter
        [
          {
            label: 'Mozilla Firefox',
            cmd: 'firefox',
            picked: 0
          },
          {
            label: 'Opera browser',
            cmd: 'opera',
            picked: 0
          },
          {
            label: 'Luakit browser',
            cmd: 'luakit',
            picked: 0
          }
        ]
      end
    end
  end
end
