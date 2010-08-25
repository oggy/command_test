require 'fileutils'

module TemporaryDirectory
  def create_temporary_directory
    remove_temporary_directory
    FileUtils.mkdir_p temporary_directory
  end

  def remove_temporary_directory
    FileUtils.rm_rf temporary_directory
  end

  #
  # Return the given path relative to the temporary directory.
  #
  def temporary_path(path=nil)
    if path
      File.join(temporary_directory, path)
    else
      temporary_directory
    end
  end

  #
  # Write to the given path in the temporary directory.
  #
  # Return the full path to the file.
  #
  def write_temporary_file(path, content)
    path = temporary_path(path)
    open(path, 'w') do |file|
      file.print content
    end
    path
  end

  private  # ---------------------------------------------------------

  def temporary_directory
    "#{ROOT}/spec/tmp"
  end
end

Spec::Runner.configure do |config|
  config.before { create_temporary_directory }
  config.after(:all) { remove_temporary_directory }
  config.include TemporaryDirectory
end
