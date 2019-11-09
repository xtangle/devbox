require_relative './platform'

module Provision
  module Display
    def self.get_display_info
      if Platform::os_type == Platform::WINDOWS
        description = `wmic path Win32_VideoController get VideoModeDescription`
        width, height, num_colors = description.match(/(\d+) x (\d+) x (\d+)/).captures
        color_depth = Math.log2(num_colors.to_i)
      else
        width = `xwininfo -root | grep Width:`.match(/.*:\s+(\d+)/).captures[0]
        height = `xwininfo -root | grep Height:`.match(/.*:\s+(\d+)/).captures[0]
        color_depth = `xwininfo -root | grep Depth:`.match(/.*:\s+(\d+)/).captures[0]
      end
      {
        'display_width' => width.to_i,
        'display_height' => height.to_i,
        'display_color_depth' => color_depth.to_i
      }
    end
  end
end
