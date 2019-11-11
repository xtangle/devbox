module Provision
  module Platform
    WINDOWS = 1
    UNIX_LIKE = 2

    def self.os_type
      if RUBY_PLATFORM =~ /win32/ || RUBY_PLATFORM =~ /mingw32/
        WINDOWS
      else
        UNIX_LIKE
      end
    end
  end
end
