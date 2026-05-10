set moduleName conv1_pragma
set isTopModule 0
set isCombinational 0
set isDatapathOnly 0
set isPipelined 0
set pipeline_type none
set FunctionProtocol ap_ctrl_hs
set isOneStateSeq 0
set ProfileFlag 0
set StallSigGenFlag 0
set isEnableWaveformDebug 1
set hasInterrupt 0
set DLRegFirstOffset 0
set DLRegItemOffset 0
set C_modelName {conv1_pragma}
set C_modelType { void 0 }
set C_modelArgList {
	{ x int 8 regular {array 1024 { 1 1 } 1 1 }  }
	{ y_0 int 8 regular {array 1176 { 3 0 } 0 1 }  }
	{ y_1 int 8 regular {array 1176 { 3 0 } 0 1 }  }
}
set hasAXIMCache 0
set C_modelArgMapList {[ 
	{ "Name" : "x", "interface" : "memory", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "y_0", "interface" : "memory", "bitwidth" : 8, "direction" : "WRITEONLY"} , 
 	{ "Name" : "y_1", "interface" : "memory", "bitwidth" : 8, "direction" : "WRITEONLY"} ]}
# RTL Port declarations: 
set portNum 20
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ x_address0 sc_out sc_lv 10 signal 0 } 
	{ x_ce0 sc_out sc_logic 1 signal 0 } 
	{ x_q0 sc_in sc_lv 8 signal 0 } 
	{ x_address1 sc_out sc_lv 10 signal 0 } 
	{ x_ce1 sc_out sc_logic 1 signal 0 } 
	{ x_q1 sc_in sc_lv 8 signal 0 } 
	{ y_0_address1 sc_out sc_lv 11 signal 1 } 
	{ y_0_ce1 sc_out sc_logic 1 signal 1 } 
	{ y_0_we1 sc_out sc_logic 1 signal 1 } 
	{ y_0_d1 sc_out sc_lv 8 signal 1 } 
	{ y_1_address1 sc_out sc_lv 11 signal 2 } 
	{ y_1_ce1 sc_out sc_logic 1 signal 2 } 
	{ y_1_we1 sc_out sc_logic 1 signal 2 } 
	{ y_1_d1 sc_out sc_lv 8 signal 2 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "x_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "x", "role": "address0" }} , 
 	{ "name": "x_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "x", "role": "ce0" }} , 
 	{ "name": "x_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "x", "role": "q0" }} , 
 	{ "name": "x_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "x", "role": "address1" }} , 
 	{ "name": "x_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "x", "role": "ce1" }} , 
 	{ "name": "x_q1", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "x", "role": "q1" }} , 
 	{ "name": "y_0_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "y_0", "role": "address1" }} , 
 	{ "name": "y_0_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "y_0", "role": "ce1" }} , 
 	{ "name": "y_0_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "y_0", "role": "we1" }} , 
 	{ "name": "y_0_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "y_0", "role": "d1" }} , 
 	{ "name": "y_1_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "y_1", "role": "address1" }} , 
 	{ "name": "y_1_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "y_1", "role": "ce1" }} , 
 	{ "name": "y_1_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "y_1", "role": "we1" }} , 
 	{ "name": "y_1_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "y_1", "role": "d1" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "78"],
		"CDFG" : "conv1_pragma",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "17671", "EstimateLatencyMax" : "17671",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "x", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "26", "SubInstance" : "grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445", "Port" : "x", "Inst_start_state" : "3", "Inst_end_state" : "4"}]},
			{"Name" : "y_0", "Type" : "Memory", "Direction" : "O",
				"SubConnect" : [
					{"ID" : "26", "SubInstance" : "grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445", "Port" : "y_0", "Inst_start_state" : "3", "Inst_end_state" : "4"}]},
			{"Name" : "y_1", "Type" : "Memory", "Direction" : "O",
				"SubConnect" : [
					{"ID" : "26", "SubInstance" : "grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445", "Port" : "y_1", "Inst_start_state" : "3", "Inst_end_state" : "4"}]},
			{"Name" : "LENET_C1_W_0_0_0", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "LENET_C1_W_0_0_1", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "LENET_C1_W_0_0_2", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "LENET_C1_W_0_0_3", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "LENET_C1_W_0_0_4", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "LENET_C1_W_0_1_0", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "LENET_C1_W_0_1_1", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "LENET_C1_W_0_1_2", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "LENET_C1_W_0_1_3", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "LENET_C1_W_0_1_4", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "LENET_C1_W_0_2_0", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "LENET_C1_W_0_2_1", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "LENET_C1_W_0_2_2", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "LENET_C1_W_0_2_3", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "LENET_C1_W_0_2_4", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "LENET_C1_W_0_3_0", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "LENET_C1_W_0_3_1", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "LENET_C1_W_0_3_2", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "LENET_C1_W_0_3_3", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "LENET_C1_W_0_3_4", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "LENET_C1_W_0_4_0", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "LENET_C1_W_0_4_1", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "LENET_C1_W_0_4_2", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "LENET_C1_W_0_4_3", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "LENET_C1_W_0_4_4", "Type" : "Memory", "Direction" : "I"}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_117_1", "PipelineType" : "no",
				"LoopDec" : {"FSMBitwidth" : "4", "FirstState" : "ap_ST_fsm_state2", "LastState" : ["ap_ST_fsm_state4"], "QuitState" : ["ap_ST_fsm_state2"], "PreState" : ["ap_ST_fsm_state1"], "PostState" : ["ap_ST_fsm_state1"], "OneDepthLoop" : "0", "OneStateBlock": ""}}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LENET_C1_W_0_0_0_U", "Parent" : "0"},
	{"ID" : "2", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LENET_C1_W_0_0_1_U", "Parent" : "0"},
	{"ID" : "3", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LENET_C1_W_0_0_2_U", "Parent" : "0"},
	{"ID" : "4", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LENET_C1_W_0_0_3_U", "Parent" : "0"},
	{"ID" : "5", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LENET_C1_W_0_0_4_U", "Parent" : "0"},
	{"ID" : "6", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LENET_C1_W_0_1_0_U", "Parent" : "0"},
	{"ID" : "7", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LENET_C1_W_0_1_1_U", "Parent" : "0"},
	{"ID" : "8", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LENET_C1_W_0_1_2_U", "Parent" : "0"},
	{"ID" : "9", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LENET_C1_W_0_1_3_U", "Parent" : "0"},
	{"ID" : "10", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LENET_C1_W_0_1_4_U", "Parent" : "0"},
	{"ID" : "11", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LENET_C1_W_0_2_0_U", "Parent" : "0"},
	{"ID" : "12", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LENET_C1_W_0_2_1_U", "Parent" : "0"},
	{"ID" : "13", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LENET_C1_W_0_2_2_U", "Parent" : "0"},
	{"ID" : "14", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LENET_C1_W_0_2_3_U", "Parent" : "0"},
	{"ID" : "15", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LENET_C1_W_0_2_4_U", "Parent" : "0"},
	{"ID" : "16", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LENET_C1_W_0_3_0_U", "Parent" : "0"},
	{"ID" : "17", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LENET_C1_W_0_3_1_U", "Parent" : "0"},
	{"ID" : "18", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LENET_C1_W_0_3_2_U", "Parent" : "0"},
	{"ID" : "19", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LENET_C1_W_0_3_3_U", "Parent" : "0"},
	{"ID" : "20", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LENET_C1_W_0_3_4_U", "Parent" : "0"},
	{"ID" : "21", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LENET_C1_W_0_4_0_U", "Parent" : "0"},
	{"ID" : "22", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LENET_C1_W_0_4_1_U", "Parent" : "0"},
	{"ID" : "23", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LENET_C1_W_0_4_2_U", "Parent" : "0"},
	{"ID" : "24", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LENET_C1_W_0_4_3_U", "Parent" : "0"},
	{"ID" : "25", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.LENET_C1_W_0_4_4_U", "Parent" : "0"},
	{"ID" : "26", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445", "Parent" : "0", "Child" : ["27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", "51", "52", "53", "54", "55", "56", "57", "58", "59", "60", "61", "62", "63", "64", "65", "66", "67", "68", "69", "70", "71", "72", "73", "74", "75", "76", "77"],
		"CDFG" : "conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "5887", "EstimateLatencyMax" : "5887",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "sub_ln131", "Type" : "None", "Direction" : "I"},
			{"Name" : "x", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "y_0", "Type" : "Memory", "Direction" : "O"},
			{"Name" : "y_1", "Type" : "Memory", "Direction" : "O"},
			{"Name" : "LENET_C1_W_0_4_0_load_cast", "Type" : "None", "Direction" : "I"},
			{"Name" : "LENET_C1_W_0_2_3_load_cast", "Type" : "None", "Direction" : "I"},
			{"Name" : "LENET_C1_W_0_4_2_load_cast", "Type" : "None", "Direction" : "I"},
			{"Name" : "LENET_C1_W_0_1_2_load_cast", "Type" : "None", "Direction" : "I"},
			{"Name" : "LENET_C1_W_0_1_3_load_cast", "Type" : "None", "Direction" : "I"},
			{"Name" : "LENET_C1_W_0_2_2_load_cast", "Type" : "None", "Direction" : "I"},
			{"Name" : "LENET_C1_W_0_3_3_load_cast", "Type" : "None", "Direction" : "I"},
			{"Name" : "LENET_C1_W_0_1_1_load_cast", "Type" : "None", "Direction" : "I"},
			{"Name" : "LENET_C1_W_0_0_0_load_cast", "Type" : "None", "Direction" : "I"},
			{"Name" : "LENET_C1_W_0_1_4_load_cast", "Type" : "None", "Direction" : "I"},
			{"Name" : "LENET_C1_W_0_4_3_load_cast", "Type" : "None", "Direction" : "I"},
			{"Name" : "LENET_C1_W_0_2_1_load_cast", "Type" : "None", "Direction" : "I"},
			{"Name" : "LENET_C1_W_0_1_0_load_cast", "Type" : "None", "Direction" : "I"},
			{"Name" : "LENET_C1_W_0_4_1_load_cast", "Type" : "None", "Direction" : "I"},
			{"Name" : "LENET_C1_W_0_0_1_load_cast", "Type" : "None", "Direction" : "I"},
			{"Name" : "LENET_C1_W_0_0_4_load_cast", "Type" : "None", "Direction" : "I"},
			{"Name" : "LENET_C1_W_0_3_4_load_cast", "Type" : "None", "Direction" : "I"},
			{"Name" : "LENET_C1_W_0_0_3_load_cast", "Type" : "None", "Direction" : "I"},
			{"Name" : "LENET_C1_W_0_2_0_load_cast", "Type" : "None", "Direction" : "I"},
			{"Name" : "LENET_C1_W_0_3_0_load_cast", "Type" : "None", "Direction" : "I"},
			{"Name" : "LENET_C1_W_0_3_1_load_cast", "Type" : "None", "Direction" : "I"},
			{"Name" : "LENET_C1_W_0_2_4_load_cast", "Type" : "None", "Direction" : "I"},
			{"Name" : "LENET_C1_W_0_0_2_load_cast", "Type" : "None", "Direction" : "I"},
			{"Name" : "LENET_C1_W_0_3_2_load_cast", "Type" : "None", "Direction" : "I"},
			{"Name" : "sext_ln118", "Type" : "None", "Direction" : "I"},
			{"Name" : "merge_i_cast", "Type" : "None", "Direction" : "I"}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_118_2_VITIS_LOOP_119_3", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "15", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage5", "LastStateIter" : "ap_enable_reg_pp0_iter1", "LastStateBlock" : "ap_block_pp0_stage5_subdone", "QuitState" : "ap_ST_fsm_pp0_stage5", "QuitStateIter" : "ap_enable_reg_pp0_iter1", "QuitStateBlock" : "ap_block_pp0_stage5_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "0"}}]},
	{"ID" : "27", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mul_8ns_7ns_15_1_1_U1", "Parent" : "26"},
	{"ID" : "28", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mul_8ns_8s_16_1_1_U2", "Parent" : "26"},
	{"ID" : "29", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mul_8ns_8s_16_1_1_U3", "Parent" : "26"},
	{"ID" : "30", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mul_8ns_8s_16_1_1_U4", "Parent" : "26"},
	{"ID" : "31", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mul_8ns_8s_16_1_1_U5", "Parent" : "26"},
	{"ID" : "32", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mul_8ns_8s_16_1_1_U6", "Parent" : "26"},
	{"ID" : "33", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mul_8ns_7ns_15_1_1_U7", "Parent" : "26"},
	{"ID" : "34", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mul_8ns_8s_16_1_1_U8", "Parent" : "26"},
	{"ID" : "35", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mul_8ns_8s_16_1_1_U9", "Parent" : "26"},
	{"ID" : "36", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mul_8ns_8s_16_1_1_U10", "Parent" : "26"},
	{"ID" : "37", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mul_8ns_8s_16_1_1_U11", "Parent" : "26"},
	{"ID" : "38", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mul_8ns_8s_16_1_1_U12", "Parent" : "26"},
	{"ID" : "39", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mul_8ns_8s_16_1_1_U13", "Parent" : "26"},
	{"ID" : "40", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mul_8ns_8s_16_1_1_U14", "Parent" : "26"},
	{"ID" : "41", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mul_8ns_8s_16_1_1_U15", "Parent" : "26"},
	{"ID" : "42", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mul_8ns_8s_16_1_1_U16", "Parent" : "26"},
	{"ID" : "43", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mul_8ns_8s_16_1_1_U17", "Parent" : "26"},
	{"ID" : "44", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mul_8ns_8s_16_1_1_U18", "Parent" : "26"},
	{"ID" : "45", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_7ns_15s_17_4_1_U19", "Parent" : "26"},
	{"ID" : "46", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_7ns_16s_17_4_1_U20", "Parent" : "26"},
	{"ID" : "47", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_7ns_15s_17_4_1_U21", "Parent" : "26"},
	{"ID" : "48", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_8s_17s_18_4_1_U22", "Parent" : "26"},
	{"ID" : "49", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_7ns_17s_18_4_1_U23", "Parent" : "26"},
	{"ID" : "50", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_7ns_15ns_16_4_1_U24", "Parent" : "26"},
	{"ID" : "51", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_8s_16s_17_4_1_U25", "Parent" : "26"},
	{"ID" : "52", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_8s_16s_17_4_1_U26", "Parent" : "26"},
	{"ID" : "53", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_8s_16ns_17_4_1_U27", "Parent" : "26"},
	{"ID" : "54", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_7ns_17s_18_4_1_U28", "Parent" : "26"},
	{"ID" : "55", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_7ns_16s_17_4_1_U29", "Parent" : "26"},
	{"ID" : "56", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_7ns_16s_17_4_1_U30", "Parent" : "26"},
	{"ID" : "57", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_8s_17s_18_4_1_U31", "Parent" : "26"},
	{"ID" : "58", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_6ns_15ns_16_4_1_U32", "Parent" : "26"},
	{"ID" : "59", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_7ns_16s_17_4_1_U33", "Parent" : "26"},
	{"ID" : "60", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_7ns_16s_17_4_1_U34", "Parent" : "26"},
	{"ID" : "61", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_7ns_16ns_16_4_1_U35", "Parent" : "26"},
	{"ID" : "62", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_6ns_17s_17_4_1_U36", "Parent" : "26"},
	{"ID" : "63", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_8s_16s_17_4_1_U37", "Parent" : "26"},
	{"ID" : "64", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_8s_16s_17_4_1_U38", "Parent" : "26"},
	{"ID" : "65", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_8s_17s_18_4_1_U39", "Parent" : "26"},
	{"ID" : "66", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_8s_16s_16_4_1_U40", "Parent" : "26"},
	{"ID" : "67", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_8s_16s_16_4_1_U41", "Parent" : "26"},
	{"ID" : "68", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_7s_16s_17_4_1_U42", "Parent" : "26"},
	{"ID" : "69", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_7ns_16s_17_4_1_U43", "Parent" : "26"},
	{"ID" : "70", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_7ns_16s_17_4_1_U44", "Parent" : "26"},
	{"ID" : "71", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_8s_16s_17_4_1_U45", "Parent" : "26"},
	{"ID" : "72", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_8s_16s_17_4_1_U46", "Parent" : "26"},
	{"ID" : "73", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_7ns_16s_17_4_1_U47", "Parent" : "26"},
	{"ID" : "74", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_7s_17s_17_4_1_U48", "Parent" : "26"},
	{"ID" : "75", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_8s_16s_17_4_1_U49", "Parent" : "26"},
	{"ID" : "76", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_8s_17s_18_4_1_U50", "Parent" : "26"},
	{"ID" : "77", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.flow_control_loop_pipe_sequential_init_U", "Parent" : "26"},
	{"ID" : "78", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mux_4_2_15_1_1_U96", "Parent" : "0"}]}


set ArgLastReadFirstWriteLatency {
	conv1_pragma {
		x {Type I LastRead 15 FirstWrite -1}
		y_0 {Type O LastRead -1 FirstWrite 19}
		y_1 {Type O LastRead -1 FirstWrite 19}
		LENET_C1_W_0_0_0 {Type I LastRead -1 FirstWrite -1}
		LENET_C1_W_0_0_1 {Type I LastRead -1 FirstWrite -1}
		LENET_C1_W_0_0_2 {Type I LastRead -1 FirstWrite -1}
		LENET_C1_W_0_0_3 {Type I LastRead -1 FirstWrite -1}
		LENET_C1_W_0_0_4 {Type I LastRead -1 FirstWrite -1}
		LENET_C1_W_0_1_0 {Type I LastRead -1 FirstWrite -1}
		LENET_C1_W_0_1_1 {Type I LastRead -1 FirstWrite -1}
		LENET_C1_W_0_1_2 {Type I LastRead -1 FirstWrite -1}
		LENET_C1_W_0_1_3 {Type I LastRead -1 FirstWrite -1}
		LENET_C1_W_0_1_4 {Type I LastRead -1 FirstWrite -1}
		LENET_C1_W_0_2_0 {Type I LastRead -1 FirstWrite -1}
		LENET_C1_W_0_2_1 {Type I LastRead -1 FirstWrite -1}
		LENET_C1_W_0_2_2 {Type I LastRead -1 FirstWrite -1}
		LENET_C1_W_0_2_3 {Type I LastRead -1 FirstWrite -1}
		LENET_C1_W_0_2_4 {Type I LastRead -1 FirstWrite -1}
		LENET_C1_W_0_3_0 {Type I LastRead -1 FirstWrite -1}
		LENET_C1_W_0_3_1 {Type I LastRead -1 FirstWrite -1}
		LENET_C1_W_0_3_2 {Type I LastRead -1 FirstWrite -1}
		LENET_C1_W_0_3_3 {Type I LastRead -1 FirstWrite -1}
		LENET_C1_W_0_3_4 {Type I LastRead -1 FirstWrite -1}
		LENET_C1_W_0_4_0 {Type I LastRead -1 FirstWrite -1}
		LENET_C1_W_0_4_1 {Type I LastRead -1 FirstWrite -1}
		LENET_C1_W_0_4_2 {Type I LastRead -1 FirstWrite -1}
		LENET_C1_W_0_4_3 {Type I LastRead -1 FirstWrite -1}
		LENET_C1_W_0_4_4 {Type I LastRead -1 FirstWrite -1}}
	conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3 {
		sub_ln131 {Type I LastRead 0 FirstWrite -1}
		x {Type I LastRead 15 FirstWrite -1}
		y_0 {Type O LastRead -1 FirstWrite 19}
		y_1 {Type O LastRead -1 FirstWrite 19}
		LENET_C1_W_0_4_0_load_cast {Type I LastRead 0 FirstWrite -1}
		LENET_C1_W_0_2_3_load_cast {Type I LastRead 0 FirstWrite -1}
		LENET_C1_W_0_4_2_load_cast {Type I LastRead 0 FirstWrite -1}
		LENET_C1_W_0_1_2_load_cast {Type I LastRead 0 FirstWrite -1}
		LENET_C1_W_0_1_3_load_cast {Type I LastRead 0 FirstWrite -1}
		LENET_C1_W_0_2_2_load_cast {Type I LastRead 0 FirstWrite -1}
		LENET_C1_W_0_3_3_load_cast {Type I LastRead 0 FirstWrite -1}
		LENET_C1_W_0_1_1_load_cast {Type I LastRead 0 FirstWrite -1}
		LENET_C1_W_0_0_0_load_cast {Type I LastRead 0 FirstWrite -1}
		LENET_C1_W_0_1_4_load_cast {Type I LastRead 0 FirstWrite -1}
		LENET_C1_W_0_4_3_load_cast {Type I LastRead 0 FirstWrite -1}
		LENET_C1_W_0_2_1_load_cast {Type I LastRead 0 FirstWrite -1}
		LENET_C1_W_0_1_0_load_cast {Type I LastRead 0 FirstWrite -1}
		LENET_C1_W_0_4_1_load_cast {Type I LastRead 0 FirstWrite -1}
		LENET_C1_W_0_0_1_load_cast {Type I LastRead 0 FirstWrite -1}
		LENET_C1_W_0_0_4_load_cast {Type I LastRead 0 FirstWrite -1}
		LENET_C1_W_0_3_4_load_cast {Type I LastRead 0 FirstWrite -1}
		LENET_C1_W_0_0_3_load_cast {Type I LastRead 0 FirstWrite -1}
		LENET_C1_W_0_2_0_load_cast {Type I LastRead 0 FirstWrite -1}
		LENET_C1_W_0_3_0_load_cast {Type I LastRead 0 FirstWrite -1}
		LENET_C1_W_0_3_1_load_cast {Type I LastRead 0 FirstWrite -1}
		LENET_C1_W_0_2_4_load_cast {Type I LastRead 0 FirstWrite -1}
		LENET_C1_W_0_0_2_load_cast {Type I LastRead 0 FirstWrite -1}
		LENET_C1_W_0_3_2_load_cast {Type I LastRead 0 FirstWrite -1}
		sext_ln118 {Type I LastRead 0 FirstWrite -1}
		merge_i_cast {Type I LastRead 0 FirstWrite -1}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "17671", "Max" : "17671"}
	, {"Name" : "Interval", "Min" : "17671", "Max" : "17671"}
]}

set PipelineEnableSignalInfo {[
]}

set Spec2ImplPortList { 
	x { ap_memory {  { x_address0 mem_address 1 10 }  { x_ce0 mem_ce 1 1 }  { x_q0 mem_dout 0 8 }  { x_address1 MemPortADDR2 1 10 }  { x_ce1 MemPortCE2 1 1 }  { x_q1 MemPortDOUT2 0 8 } } }
	y_0 { ap_memory {  { y_0_address1 MemPortADDR2 1 11 }  { y_0_ce1 MemPortCE2 1 1 }  { y_0_we1 MemPortWE2 1 1 }  { y_0_d1 MemPortDIN2 1 8 } } }
	y_1 { ap_memory {  { y_1_address1 MemPortADDR2 1 11 }  { y_1_ce1 MemPortCE2 1 1 }  { y_1_we1 MemPortWE2 1 1 }  { y_1_d1 MemPortDIN2 1 8 } } }
}
