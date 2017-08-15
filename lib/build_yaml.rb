require "yaml"
require "erb"
require "pathname"

class BuildYAML
  class << self
    def root
      Pathname.new(File.expand_path('..', __dir__))
    end

    def read_yaml(files)
      build_yaml = new
      data = build_yaml.load_files(files)
      build_yaml.aggregate(data)
    end
  end

  def load_files(files)
    yamls = []
    files.each do |f|
      next unless File.exist?(f)
      begin
        yamls << YAML.load(open(f).read)
      rescue => e
        STDERR.puts e.class
        STDERR.puts e.message
        e.backtrace.each{|s| STDERR.puts s }
      end
    end
    yamls
  end

  def aggregate(data)
    yaml = {}
    data.each do |y|
      yaml = y if yaml == {}
      next if yaml == y

      yaml.each do |k, v|
        case v
        when Hash
          yaml[k].merge!(y[k]) unless y[k].nil?
        when Array
          yaml[k] += y[k] unless y[k].nil?
        end
      end
    end
    yaml
  end
end
