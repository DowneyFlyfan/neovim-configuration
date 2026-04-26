-- Custom nvim-cmp source for Synopsys DC / Innovus TCL snippets
-- Provides LSP-style completion with full command names

local source = {}

source.new = function()
	return setmetatable({}, { __index = source })
end

source.get_keyword_pattern = function()
	return [[\k\+]]
end

source.is_available = function()
	return vim.bo.filetype == "tcl"
end

source.get_trigger_characters = function()
	return {}
end

-- insertTextFormat = 2 means Snippet (LSP spec)
local SNP = 2

-- Helper: build a completion item
-- label = full command name shown in menu
-- body = snippet body inserted on confirm
-- desc = documentation string
local function item(label, body, desc)
	return {
		label = label,
		insertText = body,
		insertTextFormat = SNP,
		detail = desc or "",
		kind = 3, -- Function (like LSP)
	}
end

-- All TCL completion items
local items = {
	-- ============ Read / Analyze / Elaborate ============
	item("read_verilog", "read_verilog ${1:file.v}", "Reads design files in Verilog format"),
	item("read_sverilog", "read_sverilog ${1:file.sv}", "Reads design files in SystemVerilog format"),
	item("read_vhdl", "read_vhdl ${1:file.vhd}", "Reads design files in VHDL (VHSIC Hardware Description Language) format"),
	item("read_ddc", "read_ddc ${1:file.ddc}", "Reads design files in .ddc (Synopsys logical database) format"),
	item("read_db", "read_db ${1:file.db}", "Reads design/library files in .db (Synopsys database) format"),
	item("analyze", "analyze -format ${1|sverilog,verilog,vhdl|} ${2:file_list}", "Analyzes HDL (Hardware Description Language) source files and stores templates"),
	item("analyze -library", "analyze -format ${1|sverilog,verilog,vhdl|} -library ${2:WORK} ${3:file_list}", "Analyzes HDL and stores into a specified library"),
	item("elaborate", "elaborate ${1:design_name}", "Builds a design from intermediate format of a Verilog module or VHDL entity"),
	item("elaborate -parameters", "elaborate ${1:design_name} -parameters {${2:PARAM=value}}", "Elaborate with parameters"),

	-- ============ Design Setup ============
	item("current_design", "current_design ${1:design_name}", "Sets the working design"),
	item("link", "link", "Resolves design references"),
	item("uniquify", "uniquify", "Creates unique design for each cell instance"),
	item("remove_design", "remove_design -all", "Removes designs from memory"),
	item("set_svf", "set_svf ${1:design.svf}", "Generates Formality setup file for compare point matching"),

	-- ============ Clock Constraints ============
	item("create_clock", "create_clock -name ${1:CLK} -period ${2:10} [get_ports ${3:clk}]", "Creates a clock and defines waveform"),
	item("create_clock -virtual", "create_clock -name ${1:VCLK} -period ${2:10}", "Virtual clock (no source port)"),
	item("create_clock -waveform", "create_clock -name ${1:CLK} -period ${2:10} -waveform {${3:0 5}} [get_ports ${4:clk}]", "Clock with explicit waveform edges"),
	item("create_generated_clock", "create_generated_clock -name ${1:GCLK} -source [get_ports ${2:clk}] -divide_by ${3:2} [get_pins ${4:pin}]", "Creates a generated clock derived from a master clock"),
	item("set_clock_latency", "set_clock_latency ${1:0.5} [get_clocks ${2:CLK}]", "Specifies clock network latency"),
	item("set_clock_uncertainty", "set_clock_uncertainty ${1:0.1} [get_clocks ${2:CLK}]", "Specifies clock skew/jitter"),
	item("set_clock_uncertainty -inter", "set_clock_uncertainty ${1:0.1} -from [get_clocks ${2:CLK1}] -to [get_clocks ${3:CLK2}]", "Inter-clock uncertainty"),
	item("set_clock_transition", "set_clock_transition ${1:0.1} [get_clocks ${2:CLK}]", "Sets transition time at clock pins of sequential devices"),
	item("set_propagated_clock", "set_propagated_clock [${1|all_clocks,get_clocks CLK|}]", "Specifies propagated (rather than ideal) clock latency"),
	item("set_clock_groups", "set_clock_groups -${1|asynchronous,logically_exclusive,physically_exclusive|}\n  -group [get_clocks ${2:CLK1}] \\\n  -group [get_clocks ${3:CLK2}]", "Specifies mutually exclusive or asynchronous clock groups"),

	-- ============ Clock Gating ============
	item("set_clock_gating_style", "set_clock_gating_style ${1|-sequential_cell latch,-sequential_cell none|} -minimum_bitwidth ${2:4}", "Sets style for clock-gate insertion/replacement"),
	item("set_clock_gating_check", "set_clock_gating_check -setup ${1:0.1} -hold ${2:0.1}", "Sets setup/hold checks on clock-gating cells"),
	item("insert_clock_gating", "insert_clock_gating", "Performs clock gating on GTECH netlist"),

	-- ============ IO Constraints ============
	item("set_input_delay", "set_input_delay ${1:2.0} -clock [get_clocks ${2:CLK}] [get_ports ${3:port}]", "Sets input arrival time relative to clock"),
	item("set_input_delay -max -min", "set_input_delay -max ${1:2.0} -clock [get_clocks ${2:CLK}] [get_ports ${3:port}]\nset_input_delay -min ${4:0.5} -clock [get_clocks ${2:CLK}] [get_ports ${3:port}]", "Sets input delay with separate max/min values"),
	item("set_output_delay", "set_output_delay ${1:2.0} -clock [get_clocks ${2:CLK}] [get_ports ${3:port}]", "Sets output required time relative to clock"),
	item("set_output_delay -max -min", "set_output_delay -max ${1:2.0} -clock [get_clocks ${2:CLK}] [get_ports ${3:port}]\nset_output_delay -min ${4:0.5} -clock [get_clocks ${2:CLK}] [get_ports ${3:port}]", "Sets output delay with separate max/min values"),
	item("set_input_transition", "set_input_transition ${1:0.1} [get_ports ${2:port}]", "Sets transition time on input ports"),
	item("set_load", "set_load ${1:0.5} [get_ports ${2:port}]", "Sets capacitive load attribute on ports/nets"),
	item("set_driving_cell", "set_driving_cell -lib_cell ${1:INVX1} -pin ${2:Y} [get_ports ${3:port}]", "Sets a library cell as driver for input/inout ports"),

	-- ============ Timing Exceptions ============
	item("set_max_delay", "set_max_delay ${1:5.0} -from [get_ports ${2:in}] -to [get_ports ${3:out}]", "Specifies maximum delay target for paths"),
	item("set_min_delay", "set_min_delay ${1:1.0} -from [get_ports ${2:in}] -to [get_ports ${3:out}]", "Specifies minimum delay target for paths"),
	item("set_false_path", "set_false_path -from [get_ports ${1:in}] -to [get_ports ${2:out}]", "Removes timing constraints from paths"),
	item("set_false_path -through", "set_false_path -through [get_pins ${1:pin}]", "False path through a pin or net"),
	item("set_multicycle_path", "set_multicycle_path ${1:2} -${2|setup,hold|} -from [get_clocks ${3:CLK1}] -to [get_clocks ${4:CLK2}]", "Modifies single-cycle timing relationship"),
	item("set_disable_timing", "set_disable_timing [get_cells ${1:cell}] -from ${2:A} -to ${3:Y}", "Disables timing arcs on cells"),
	item("set_case_analysis", "set_case_analysis ${1|0,1,rising,falling|} [get_ports ${2:port}]", "Specifies constant value on a port or pin"),

	-- ============ Design Constraints ============
	item("set_max_area", "set_max_area ${1:0}", "Sets max_area attribute on current design"),
	item("set_max_fanout", "set_max_fanout ${1:16} [${2|current_design,get_ports port|}]", "Sets max_fanout attribute"),
	item("set_max_transition", "set_max_transition ${1:0.5} [current_design]", "Sets maximum transition time"),
	item("set_max_capacitance", "set_max_capacitance ${1:0.5} [current_design]", "Sets max_capacitance attribute"),
	item("set_dont_touch", "set_dont_touch [get_cells ${1:cell}]", "Prevents modification during optimization"),
	item("set_dont_use", "set_dont_use [get_lib_cells ${1:lib/cell}]", "Prevents use of library cells during mapping"),
	item("set_fix_hold", "set_fix_hold [${1|all_clocks,get_clocks CLK|}]", "Sets fix_hold attribute on clocks"),
	item("set_ideal_network", "set_ideal_network [get_ports ${1:port}]", "Marks ports/pins as ideal network (zero delay/transition)"),
	item("group_path", "group_path -name ${1:group} -weight ${2:1.0} -from [get_clocks ${3:CLK}] -to [get_clocks ${4:CLK}]", "Groups paths for cost function calculations"),

	-- ============ Operating Conditions ============
	item("set_wire_load_model", "set_wire_load_model -name ${1:model} -library ${2:lib}", "Selects a wire load model for net delay estimation"),
	item("set_operating_conditions", "set_operating_conditions -max ${1:WORST} -min ${2:BEST}", "Defines PVT (Process, Voltage, Temperature) operating conditions"),
	item("set_timing_derate", "set_timing_derate -${1|early,late|} ${2:0.95} [${3|current_design,get_cells cell|}]", "Sets derating factor for OCV (On-Chip Variation) analysis"),
	item("set_switching_activity", "set_switching_activity -static_probability ${1:0.5} -toggle_rate ${2:0.1} -period ${3:10} [get_ports ${4:port}]", "Annotates switching activity on nets/pins/ports/cells"),

	-- ============ Hierarchy ============
	item("ungroup", "ungroup ${1|-all -flatten,[get_cells cell]|}", "Removes a level of hierarchy"),
	item("set_ungroup", "set_ungroup [get_cells ${1:cell}] ${2|true,false|}", "Sets ungroup attribute on designs/cells"),
	item("set_flatten", "set_flatten ${1|true,false|} -effort ${2|medium,low,high|}", "Sets flatten attribute on design"),
	item("set_structure", "set_structure ${1|true,false|}", "Sets structure attributes for boolean optimization"),
	item("set_boundary_optimization", "set_boundary_optimization [${1|get_cells cell,current_design|}] ${2|true,false|}", "Controls boundary optimization on cells/designs"),

	-- ============ Compile ============
	item("compile", "compile -map_effort ${1|medium,high|}", "Logic-level and gate-level synthesis"),
	item("compile -options", "compile -map_effort ${1|high,medium|} -area_effort ${2|high,medium,none|}", "Compile with area effort and options"),
	item("compile_ultra", "compile_ultra", "High-effort compile for better QoR (Quality of Results)"),
	item("compile_ultra -incremental", "compile_ultra -incremental", "Incremental compile on already-mapped design"),
	item("compile_ultra -gate_clock", "compile_ultra -gate_clock", "Compile with automatic clock gating"),
	item("compile_ultra -scan", "compile_ultra -scan", "Compile with scan chain insertion"),

	-- ============ Naming ============
	item("define_name_rules", "define_name_rules ${1:verilog} -allowed {${2:a-zA-Z0-9_}} -max_length ${3:255} -replacement_char {_}", "Defines naming rules for output netlist"),
	item("change_names", "change_names -rules ${1:verilog} -hierarchy", "Changes names of ports/cells/nets to match rules"),

	-- ============ Read Constraints / Activity ============
	item("read_sdc", "read_sdc ${1:constraints.sdc}", "Reads SDC (Synopsys Design Constraints) file"),
	item("read_sdf", "read_sdf ${1:file.sdf}", "Reads SDF (Standard Delay Format) back-annotation file"),
	item("read_saif", "read_saif -input ${1:file.saif} -instance_name ${2:tb/DUT}", "Reads SAIF (Switching Activity Interchange Format) file"),

	-- ============ Reports ============
	item("report_timing", "report_timing", "Displays timing path information"),
	item("report_timing -detailed", "report_timing -path_type full -delay_type ${1|max,min|} -max_paths ${2:10} -nworst ${3:1} -input_pins -nets -transition_time -capacitance -significant_digits ${4:3}", "Detailed timing report with all fields"),
	item("report_timing -from -to", "report_timing -from [get_ports ${1:in}] -to [get_ports ${2:out}]", "Timing report for specific path endpoints"),
	item("report_area", "report_area${1| , -hierarchy|}", "Displays area information for current design"),
	item("report_power", "report_power${1| , -hierarchy, -verbose, -analysis_effort high|}", "Calculates and reports dynamic and static power"),
	item("report_constraint", "report_constraint ${1|-all_violators,-verbose,-all_violators -verbose|}", "Displays constraint violation information"),
	item("report_qor", "report_qor", "Displays QoR (Quality of Results) summary"),
	item("report_clock", "report_clock -attributes -skew", "Displays clock network information"),
	item("report_clock_gating", "report_clock_gating", "Reports clock-gating insertion details"),
	item("report_design", "report_design", "Displays design attributes and statistics"),
	item("report_cell", "report_cell", "Displays cell instance information"),
	item("report_net", "report_net", "Reports net connectivity and fanout"),
	item("report_port", "report_port -verbose", "Displays port attributes and constraints"),
	item("report_reference", "report_reference${1| , -hierarchy|}", "Displays design/library reference information"),
	item("report_compile_options", "report_compile_options", "Displays current compile option settings"),

	-- ============ Checks ============
	item("check_design", "check_design${1| , -summary|}", "Checks current design for consistency errors"),
	item("check_timing", "check_timing", "Checks for unconstrained or problematic timing"),

	-- ============ Write / Output ============
	item("write_file", "write_file -format ${1|ddc,verilog|} -hierarchy -output ${2:output}.${3|ddc,v|}", "Writes design netlist to file"),
	item("write_sdc", "write_sdc ${1:output.sdc}", "Writes SDC (Synopsys Design Constraints) file"),
	item("write_sdf", "write_sdf ${1:output.sdf}", "Writes SDF (Standard Delay Format) file"),

	-- ============ Collections ============
	item("get_ports", "get_ports ${1:*}", "Returns collection of ports from current design"),
	item("get_pins", "get_pins ${1:*/}", "Returns collection of cell pins"),
	item("get_nets", "get_nets ${1:*}", "Returns collection of nets"),
	item("get_cells", "get_cells ${1:*}", "Returns collection of cell instances"),
	item("get_clocks", "get_clocks ${1:*}", "Returns collection of defined clocks"),
	item("get_libs", "get_libs ${1:*}", "Returns collection of loaded libraries"),
	item("get_lib_cells", "get_lib_cells ${1:*/}", "Returns collection of library cells"),
	item("get_lib_pins", "get_lib_pins ${1:*/*/}", "Returns collection of library cell pins"),
	item("all_inputs", "all_inputs", "Collection of all input/inout ports"),
	item("all_outputs", "all_outputs", "Collection of all output/inout ports"),
	item("all_clocks", "all_clocks", "Collection of all defined clocks"),
	item("all_registers", "all_registers", "Collection of all sequential cells/pins"),
	item("foreach_in_collection", "foreach_in_collection ${1:item} [${2:collection}] {\n  $0\n}", "Iterates over objects in a collection"),
	item("sizeof_collection", "sizeof_collection [${1:collection}]", "Returns number of objects in a collection"),
	item("add_to_collection", "add_to_collection [${1:collection}] [${2:objects}]", "Adds objects to an existing collection"),
	item("remove_from_collection", "remove_from_collection [${1:collection}] [${2:objects}]", "Removes objects from a collection"),
	item("filter_collection", 'filter_collection [${1:collection}] "${2:attribute == value}"', "Filters collection by attribute expression"),
	item("get_attribute", "get_attribute [${1:object}] ${2:attribute_name}", "Returns attribute value of an object"),
	item("set_attribute", "set_attribute [${1:object}] ${2:attribute_name} ${3:value}", "Sets attribute value on an object"),

	-- ============ Redirect Output ============
	item("redirect", "redirect ${1:file.rpt} {${2:command}}", "Redirects command output to a file"),

	-- ============ Common Flow Templates ============
	item("dc_synthesis_flow", table.concat({
		'#========================================',
		'#  Setup',
		'#========================================',
		'',
		'set DESIGN_NAME "${1:top}"',
		'set CLK_NAME    "${2:clk}"',
		'set CLK_PERIOD  ${3:10}',
		'',
		'#========================================',
		'#  Read Design',
		'#========================================',
		'',
		'analyze -format ${4|sverilog,verilog|} [glob ../rtl/*.sv]',
		'elaborate \\$DESIGN_NAME',
		'current_design \\$DESIGN_NAME',
		'link',
		'',
		'#========================================',
		'#  Constraints',
		'#========================================',
		'',
		'create_clock -name \\$CLK_NAME \\\\',
		'  -period \\$CLK_PERIOD \\\\',
		'  [get_ports \\$CLK_NAME]',
		'',
		'set_input_delay  [expr \\$CLK_PERIOD * 0.6] \\\\',
		'  -clock [get_clocks \\$CLK_NAME] \\\\',
		'  [all_inputs]',
		'',
		'set_output_delay [expr \\$CLK_PERIOD * 0.6] \\\\',
		'  -clock [get_clocks \\$CLK_NAME] \\\\',
		'  [all_outputs]',
		'',
		'set_max_area 0',
		'',
		'#========================================',
		'#  Compile',
		'#========================================',
		'',
		'compile_ultra',
		'',
		'#========================================',
		'#  Reports',
		'#========================================',
		'',
		'report_timing',
		'report_area',
		'report_power',
		'report_constraint -all_violators',
		'report_qor',
		'',
		'#========================================',
		'#  Output',
		'#========================================',
		'',
		'write_file -format ddc -hierarchy -output "\\${DESIGN_NAME}.ddc"',
		'write_file -format verilog -hierarchy -output "\\${DESIGN_NAME}_net.v"',
		'write_sdc "\\${DESIGN_NAME}.sdc"',
		'write_sdf "\\${DESIGN_NAME}.sdf"',
	}, "\n"), "Full DC synthesis flow template"),
}

source.complete = function(self, request, callback)
	callback({ items = items, isIncomplete = false })
end

source.get_debug_name = function()
	return "dc_tcl"
end

-- Register the source
require("cmp").register_source("dc_tcl", source.new())
