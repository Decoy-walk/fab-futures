# KLayout Ruby script for DEF to GDS conversion
# Usage: klayout -zz -r def2gds.rb -rd def_file=<path> -rd gds_file=<path>

pdk_root = ENV["PDK_ROOT"] || "/foss/pdks"
lib_dir = "#{pdk_root}/sky130A/libs.ref/sky130_fd_sc_hd"

puts "============================================"
puts "DEF to GDS Conversion"
puts "============================================"

# Load standard cell GDS library first
puts "Loading standard cell GDS..."
layout = RBA::Layout.new
layout.read("#{lib_dir}/gds/sky130_fd_sc_hd.gds")

# Configure LEF/DEF reader
opt = RBA::LoadLayoutOptions.new
opt.lefdef_config.read_lef_with_def = true
opt.lefdef_config.lef_files = [
  "#{lib_dir}/techlef/sky130_fd_sc_hd__nom.tlef",
  "#{lib_dir}/lef/sky130_fd_sc_hd.lef",
  "#{lib_dir}/lef/sky130_ef_sc_hd.lef"
]

# Read DEF
puts "Reading DEF: #{$def_file}"
layout.read($def_file, opt)

# Write GDS
puts "Writing GDS: #{$gds_file}"
layout.write($gds_file)

puts "============================================"
puts "GDS written successfully!"
puts "File size: #{File.size($gds_file)} bytes"
puts "============================================"
