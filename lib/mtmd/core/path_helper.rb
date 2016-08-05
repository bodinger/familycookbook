module Utils
  class PathHelper
    def self.project_root(path)
      File.expand_path("../../../#{path}", File.dirname(__FILE__))
    end

    def self.require_folder(path, file)
      files = Dir[File.expand_path(path, file)]
      files.each { |file| require file }
    end
  end
end
