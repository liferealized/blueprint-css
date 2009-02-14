begin
  require 'rubygems'
  gem 'rmagick'
  require 'rvg/rvg'
rescue Exception => e
end

module Blueprint
  # Uses ImageMagick and RMagick to generate grid.png file
  class GridBuilder
    begin
      include Magick
    rescue Exception => e
    end

    attr_reader :column_width, :gutter_width, :output_path, :able_to_generate, :baseline_ratio, :font_size

    # ==== Options
    # * <tt>options</tt>
    #   * <tt>:column_width</tt> -- Width (in pixels) of current grid column
    #   * <tt>:gutter_width</tt> -- Width (in pixels) of current grid gutter
    #   * <tt>:output_path</tt> -- Output path of grid.png file
    #   * <tt>:baseline_ratio</tt> -- Sets the baseline ratio
    #   * <tt>:font_size</tt> -- Sets the font_size for the css
    def initialize(options={})
      @able_to_generate = Magick::Long_version rescue false
      return unless @able_to_generate
      @column_width = options[:column_width] || Blueprint::COLUMN_WIDTH
      @gutter_width = options[:gutter_width] || Blueprint::GUTTER_WIDTH
      @output_path  = options[:output_path]  || Blueprint::SOURCE_PATH
      @baseline_ratio = options[:baseline_ratio] || Blueprint::BASELINE_RATIO
      @font_size  = options[:font_size]  || Blueprint::FONT_SIZE
    end
  
    # generates (overwriting if necessary) grid.png image to be tiled in background
    def generate!
      return false unless self.able_to_generate
      total_width = self.column_width + self.gutter_width
      height = "%.0f" % (self.font_size.to_f * self.baseline_ratio.to_f )
      RVG::dpi = 100

      rvg = RVG.new((total_width.to_f/RVG::dpi).in, (height.to_f/RVG::dpi).in).viewbox(0, 0, total_width, height) do |canvas|
        canvas.background_fill = 'white'

        canvas.g do |column|
          column.rect(self.column_width, height).styles(:fill => "#e8effb")
        end

        canvas.g do |baseline|
          baseline.line(0, (height - 1), total_width, (height- 1)).styles(:fill => "#e9e9e9")
        end
      end
      
      FileUtils.mkdir self.output_path unless File.exists? self.output_path
      rvg.draw.write(File.join(self.output_path, "grid.png"))
    end
  end
end