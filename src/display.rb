module Display
  def self.get_display_info
    description = `wmic path Win32_VideoController get VideoModeDescription`
    width, height, num_colors = description.match(/(\d+) x (\d+) x (\d+)/).captures
    color_depth = Math.log2(num_colors.to_i)
    {
      :display_width => width.to_i,
      :display_height => height.to_i,
      :display_color_depth => color_depth.to_i
    }
  end
end
