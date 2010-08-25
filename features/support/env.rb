require 'fileutils'
require 'spec/expectations'

ROOT = File.dirname(File.dirname(File.dirname(__FILE__)))
TMP = "#{ROOT}/features/tmp"

Before do
  FileUtils.mkdir_p(TMP)
end

After do
  FileUtils.rm_rf(TMP)
end
