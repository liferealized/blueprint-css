require 'erb'
module Blueprint
  # Generates a custom typography file, using ERB to evaluate custom settings
  class CustomBaseline
    # path to ERB file used for CSS template
    CSS_ERB_FILE = File.join(Blueprint::LIB_PATH, 'typography.css.erb')
  
    attr_writer :baseline_ratio, :font_size

    # Baseline ratio of css.  Returns itself or Blueprint's default
    def baseline_ratio
      (@baseline_ratio || Blueprint::BASELINE_RATIO).to_f
    end

    # Font size (in pixels) of generated CSS.  Returns itself or Blueprint's default
    def font_size
      (@font_size || Blueprint::FONT_SIZE).to_i
    end
    
    # ==== Options
    # * <tt>options</tt>
    #   * <tt>:baseline_ratio</tt> -- Sets the baseline ratio
    #   * <tt>:font_size</tt> -- Sets the font_size for the css
    def initialize(options = {})
      @baseline_ratio = options[:baseline_ratio]
      @font_size = options[:font_size]
    end
  
    # Boolean value if current settings are Blueprint's defaults
    def default?
      self.baseline_ratio == Blueprint::BASELINE_RATIO && self.font_size == Blueprint::FONT_SIZE
    end
    
    # Loads grid.css.erb file, binds it to current instance, and returns output
    def generate_typography_css
      # loads up erb template to evaluate custom widths
      css = ERB::new(File.path_to_string(CustomBaseline::CSS_ERB_FILE))
    
      # bind it to this instance
      css.result(binding)
    end
  end
end