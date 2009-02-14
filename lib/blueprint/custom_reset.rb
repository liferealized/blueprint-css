require 'erb'
module Blueprint
  # Generates a custom reset file, using ERB to evaluate custom settings
  class CustomReset
    # path to ERB file used for CSS template
    CSS_ERB_FILE = File.join(Blueprint::LIB_PATH, 'reset.css.erb')
  
    attr_writer :baseline_ratio

    # Baseline ratio of css.  Returns itself or Blueprint's default
    def baseline_ratio
      (@baseline_ratio || Blueprint::BASELINE_RATIO).to_f
    end
    
    # ==== Options
    # * <tt>options</tt>
    #   * <tt>:baseline_ratio</tt> -- Sets the baseline ratio
    def initialize(options = {})
      @baseline_ratio = options[:baseline_ratio]
    end
  
    # Boolean value if current settings are Blueprint's defaults
    def default?
      self.baseline_ratio == Blueprint::BASELINE_RATIO
    end
    
    # Loads reset.css.erb file, binds it to current instance, and returns output
    def generate_reset_css
      # loads up erb template to evaluate custom widths
      css = ERB::new(File.path_to_string(CustomReset::CSS_ERB_FILE))
    
      # bind it to this instance
      css.result(binding)
    end
  end
end