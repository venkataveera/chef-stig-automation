require 'yaml'

module StigProcessor
  module ChefHelper
    
    def stig_patterns
      xccdf_patterns[cookbook_name]
    end
    
    private
    
    def xccdf_patterns
      unless defined? @xccdf_patterns
        @xccdf_patterns = Hash.new do |h,k|
          h[k] = Hash.new{|hh,kk| hh[kk] = (yaml_file("#{kk}.yml", k) rescue {}) }
        end
      end
      @xccdf_patterns
    end
    
    def yaml_file(file, cookbook=cookbook_name)
      YAML.load File.binread(xccdf_path(file, cookbook))
    end
    
    def xccdf_path(file, cookbook=cookbook_name)
      run_context.cookbook_collection[cookbook].preferred_filename_on_disk_location(run_context.node, :files, file)
    end
  end
end

::Chef::Recipe.send :include, StigProcessor::ChefHelper