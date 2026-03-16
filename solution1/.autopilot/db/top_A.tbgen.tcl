set moduleName top_A
set isTopModule 1
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
set C_modelName {top_A}
set C_modelType { void 0 }
set C_modelArgList {
	{ x int 8 regular {array 1024 { 1 1 } 1 1 }  }
	{ p1 int 8 regular {array 588 { 0 3 } 0 1 }  }
}
set hasAXIMCache 0
set C_modelArgMapList {[ 
	{ "Name" : "x", "interface" : "memory", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "p1", "interface" : "memory", "bitwidth" : 8, "direction" : "WRITEONLY"} ]}
# RTL Port declarations: 
set portNum 16
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
	{ p1_address0 sc_out sc_lv 10 signal 1 } 
	{ p1_ce0 sc_out sc_logic 1 signal 1 } 
	{ p1_we0 sc_out sc_logic 1 signal 1 } 
	{ p1_d0 sc_out sc_lv 8 signal 1 } 
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
 	{ "name": "p1_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "p1", "role": "address0" }} , 
 	{ "name": "p1_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "p1", "role": "ce0" }} , 
 	{ "name": "p1_we0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "p1", "role": "we0" }} , 
 	{ "name": "p1_d0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "p1", "role": "d0" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1", "2", "3"],
		"CDFG" : "top_A",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "18852", "EstimateLatencyMax" : "18852",
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
					{"ID" : "3", "SubInstance" : "grp_conv1_pragma_fu_233", "Port" : "x", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "p1", "Type" : "Memory", "Direction" : "O"},
			{"Name" : "LENET_C1_W_0_0_0", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_conv1_pragma_fu_233", "Port" : "LENET_C1_W_0_0_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "LENET_C1_W_0_0_1", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_conv1_pragma_fu_233", "Port" : "LENET_C1_W_0_0_1", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "LENET_C1_W_0_0_2", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_conv1_pragma_fu_233", "Port" : "LENET_C1_W_0_0_2", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "LENET_C1_W_0_0_3", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_conv1_pragma_fu_233", "Port" : "LENET_C1_W_0_0_3", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "LENET_C1_W_0_0_4", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_conv1_pragma_fu_233", "Port" : "LENET_C1_W_0_0_4", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "LENET_C1_W_0_1_0", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_conv1_pragma_fu_233", "Port" : "LENET_C1_W_0_1_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "LENET_C1_W_0_1_1", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_conv1_pragma_fu_233", "Port" : "LENET_C1_W_0_1_1", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "LENET_C1_W_0_1_2", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_conv1_pragma_fu_233", "Port" : "LENET_C1_W_0_1_2", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "LENET_C1_W_0_1_3", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_conv1_pragma_fu_233", "Port" : "LENET_C1_W_0_1_3", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "LENET_C1_W_0_1_4", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_conv1_pragma_fu_233", "Port" : "LENET_C1_W_0_1_4", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "LENET_C1_W_0_2_0", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_conv1_pragma_fu_233", "Port" : "LENET_C1_W_0_2_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "LENET_C1_W_0_2_1", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_conv1_pragma_fu_233", "Port" : "LENET_C1_W_0_2_1", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "LENET_C1_W_0_2_2", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_conv1_pragma_fu_233", "Port" : "LENET_C1_W_0_2_2", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "LENET_C1_W_0_2_3", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_conv1_pragma_fu_233", "Port" : "LENET_C1_W_0_2_3", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "LENET_C1_W_0_2_4", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_conv1_pragma_fu_233", "Port" : "LENET_C1_W_0_2_4", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "LENET_C1_W_0_3_0", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_conv1_pragma_fu_233", "Port" : "LENET_C1_W_0_3_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "LENET_C1_W_0_3_1", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_conv1_pragma_fu_233", "Port" : "LENET_C1_W_0_3_1", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "LENET_C1_W_0_3_2", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_conv1_pragma_fu_233", "Port" : "LENET_C1_W_0_3_2", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "LENET_C1_W_0_3_3", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_conv1_pragma_fu_233", "Port" : "LENET_C1_W_0_3_3", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "LENET_C1_W_0_3_4", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_conv1_pragma_fu_233", "Port" : "LENET_C1_W_0_3_4", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "LENET_C1_W_0_4_0", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_conv1_pragma_fu_233", "Port" : "LENET_C1_W_0_4_0", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "LENET_C1_W_0_4_1", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_conv1_pragma_fu_233", "Port" : "LENET_C1_W_0_4_1", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "LENET_C1_W_0_4_2", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_conv1_pragma_fu_233", "Port" : "LENET_C1_W_0_4_2", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "LENET_C1_W_0_4_3", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_conv1_pragma_fu_233", "Port" : "LENET_C1_W_0_4_3", "Inst_start_state" : "1", "Inst_end_state" : "2"}]},
			{"Name" : "LENET_C1_W_0_4_4", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "grp_conv1_pragma_fu_233", "Port" : "LENET_C1_W_0_4_4", "Inst_start_state" : "1", "Inst_end_state" : "2"}]}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_140_1_VITIS_LOOP_141_2_VITIS_LOOP_142_3", "PipelineType" : "pipeline",
				"LoopDec" : {"FSMBitwidth" : "5", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter2", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "PreState" : ["ap_ST_fsm_state2"], "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter2", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "PostState" : ["ap_ST_fsm_state8"]}}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.y1_0_U", "Parent" : "0"},
	{"ID" : "2", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.y1_1_U", "Parent" : "0"},
	{"ID" : "3", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233", "Parent" : "0", "Child" : ["4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "81"],
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
					{"ID" : "29", "SubInstance" : "grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445", "Port" : "x", "Inst_start_state" : "3", "Inst_end_state" : "4"}]},
			{"Name" : "y_0", "Type" : "Memory", "Direction" : "O",
				"SubConnect" : [
					{"ID" : "29", "SubInstance" : "grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445", "Port" : "y_0", "Inst_start_state" : "3", "Inst_end_state" : "4"}]},
			{"Name" : "y_1", "Type" : "Memory", "Direction" : "O",
				"SubConnect" : [
					{"ID" : "29", "SubInstance" : "grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445", "Port" : "y_1", "Inst_start_state" : "3", "Inst_end_state" : "4"}]},
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
	{"ID" : "4", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.LENET_C1_W_0_0_0_U", "Parent" : "3"},
	{"ID" : "5", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.LENET_C1_W_0_0_1_U", "Parent" : "3"},
	{"ID" : "6", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.LENET_C1_W_0_0_2_U", "Parent" : "3"},
	{"ID" : "7", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.LENET_C1_W_0_0_3_U", "Parent" : "3"},
	{"ID" : "8", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.LENET_C1_W_0_0_4_U", "Parent" : "3"},
	{"ID" : "9", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.LENET_C1_W_0_1_0_U", "Parent" : "3"},
	{"ID" : "10", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.LENET_C1_W_0_1_1_U", "Parent" : "3"},
	{"ID" : "11", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.LENET_C1_W_0_1_2_U", "Parent" : "3"},
	{"ID" : "12", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.LENET_C1_W_0_1_3_U", "Parent" : "3"},
	{"ID" : "13", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.LENET_C1_W_0_1_4_U", "Parent" : "3"},
	{"ID" : "14", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.LENET_C1_W_0_2_0_U", "Parent" : "3"},
	{"ID" : "15", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.LENET_C1_W_0_2_1_U", "Parent" : "3"},
	{"ID" : "16", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.LENET_C1_W_0_2_2_U", "Parent" : "3"},
	{"ID" : "17", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.LENET_C1_W_0_2_3_U", "Parent" : "3"},
	{"ID" : "18", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.LENET_C1_W_0_2_4_U", "Parent" : "3"},
	{"ID" : "19", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.LENET_C1_W_0_3_0_U", "Parent" : "3"},
	{"ID" : "20", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.LENET_C1_W_0_3_1_U", "Parent" : "3"},
	{"ID" : "21", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.LENET_C1_W_0_3_2_U", "Parent" : "3"},
	{"ID" : "22", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.LENET_C1_W_0_3_3_U", "Parent" : "3"},
	{"ID" : "23", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.LENET_C1_W_0_3_4_U", "Parent" : "3"},
	{"ID" : "24", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.LENET_C1_W_0_4_0_U", "Parent" : "3"},
	{"ID" : "25", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.LENET_C1_W_0_4_1_U", "Parent" : "3"},
	{"ID" : "26", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.LENET_C1_W_0_4_2_U", "Parent" : "3"},
	{"ID" : "27", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.LENET_C1_W_0_4_3_U", "Parent" : "3"},
	{"ID" : "28", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.LENET_C1_W_0_4_4_U", "Parent" : "3"},
	{"ID" : "29", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445", "Parent" : "3", "Child" : ["30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", "51", "52", "53", "54", "55", "56", "57", "58", "59", "60", "61", "62", "63", "64", "65", "66", "67", "68", "69", "70", "71", "72", "73", "74", "75", "76", "77", "78", "79", "80"],
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
	{"ID" : "30", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mul_8ns_7ns_15_1_1_U1", "Parent" : "29"},
	{"ID" : "31", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mul_8ns_8s_16_1_1_U2", "Parent" : "29"},
	{"ID" : "32", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mul_8ns_8s_16_1_1_U3", "Parent" : "29"},
	{"ID" : "33", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mul_8ns_8s_16_1_1_U4", "Parent" : "29"},
	{"ID" : "34", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mul_8ns_8s_16_1_1_U5", "Parent" : "29"},
	{"ID" : "35", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mul_8ns_8s_16_1_1_U6", "Parent" : "29"},
	{"ID" : "36", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mul_8ns_7ns_15_1_1_U7", "Parent" : "29"},
	{"ID" : "37", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mul_8ns_8s_16_1_1_U8", "Parent" : "29"},
	{"ID" : "38", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mul_8ns_8s_16_1_1_U9", "Parent" : "29"},
	{"ID" : "39", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mul_8ns_8s_16_1_1_U10", "Parent" : "29"},
	{"ID" : "40", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mul_8ns_8s_16_1_1_U11", "Parent" : "29"},
	{"ID" : "41", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mul_8ns_8s_16_1_1_U12", "Parent" : "29"},
	{"ID" : "42", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mul_8ns_8s_16_1_1_U13", "Parent" : "29"},
	{"ID" : "43", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mul_8ns_8s_16_1_1_U14", "Parent" : "29"},
	{"ID" : "44", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mul_8ns_8s_16_1_1_U15", "Parent" : "29"},
	{"ID" : "45", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mul_8ns_8s_16_1_1_U16", "Parent" : "29"},
	{"ID" : "46", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mul_8ns_8s_16_1_1_U17", "Parent" : "29"},
	{"ID" : "47", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mul_8ns_8s_16_1_1_U18", "Parent" : "29"},
	{"ID" : "48", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_7ns_15s_17_4_1_U19", "Parent" : "29"},
	{"ID" : "49", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_7ns_16s_17_4_1_U20", "Parent" : "29"},
	{"ID" : "50", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_7ns_15s_17_4_1_U21", "Parent" : "29"},
	{"ID" : "51", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_8s_17s_18_4_1_U22", "Parent" : "29"},
	{"ID" : "52", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_7ns_17s_18_4_1_U23", "Parent" : "29"},
	{"ID" : "53", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_7ns_15ns_16_4_1_U24", "Parent" : "29"},
	{"ID" : "54", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_8s_16s_17_4_1_U25", "Parent" : "29"},
	{"ID" : "55", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_8s_16s_17_4_1_U26", "Parent" : "29"},
	{"ID" : "56", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_8s_16ns_17_4_1_U27", "Parent" : "29"},
	{"ID" : "57", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_7ns_17s_18_4_1_U28", "Parent" : "29"},
	{"ID" : "58", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_7ns_16s_17_4_1_U29", "Parent" : "29"},
	{"ID" : "59", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_7ns_16s_17_4_1_U30", "Parent" : "29"},
	{"ID" : "60", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_8s_17s_18_4_1_U31", "Parent" : "29"},
	{"ID" : "61", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_6ns_15ns_16_4_1_U32", "Parent" : "29"},
	{"ID" : "62", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_7ns_16s_17_4_1_U33", "Parent" : "29"},
	{"ID" : "63", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_7ns_16s_17_4_1_U34", "Parent" : "29"},
	{"ID" : "64", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_7ns_16ns_16_4_1_U35", "Parent" : "29"},
	{"ID" : "65", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_6ns_17s_17_4_1_U36", "Parent" : "29"},
	{"ID" : "66", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_8s_16s_17_4_1_U37", "Parent" : "29"},
	{"ID" : "67", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_8s_16s_17_4_1_U38", "Parent" : "29"},
	{"ID" : "68", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_8s_17s_18_4_1_U39", "Parent" : "29"},
	{"ID" : "69", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_8s_16s_16_4_1_U40", "Parent" : "29"},
	{"ID" : "70", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_8s_16s_16_4_1_U41", "Parent" : "29"},
	{"ID" : "71", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_7s_16s_17_4_1_U42", "Parent" : "29"},
	{"ID" : "72", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_7ns_16s_17_4_1_U43", "Parent" : "29"},
	{"ID" : "73", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_7ns_16s_17_4_1_U44", "Parent" : "29"},
	{"ID" : "74", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_8s_16s_17_4_1_U45", "Parent" : "29"},
	{"ID" : "75", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_8s_16s_17_4_1_U46", "Parent" : "29"},
	{"ID" : "76", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_7ns_16s_17_4_1_U47", "Parent" : "29"},
	{"ID" : "77", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_7s_17s_17_4_1_U48", "Parent" : "29"},
	{"ID" : "78", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_8s_16s_17_4_1_U49", "Parent" : "29"},
	{"ID" : "79", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.mac_muladd_8ns_8s_17s_18_4_1_U50", "Parent" : "29"},
	{"ID" : "80", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.grp_conv1_pragma_Pipeline_VITIS_LOOP_118_2_VITIS_LOOP_119_3_fu_445.flow_control_loop_pipe_sequential_init_U", "Parent" : "29"},
	{"ID" : "81", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.grp_conv1_pragma_fu_233.mux_4_2_15_1_1_U96", "Parent" : "3"}]}


set ArgLastReadFirstWriteLatency {
	top_A {
		x {Type I LastRead 15 FirstWrite -1}
		p1 {Type O LastRead -1 FirstWrite 6}
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
	{"Name" : "Latency", "Min" : "18852", "Max" : "18852"}
	, {"Name" : "Interval", "Min" : "18853", "Max" : "18853"}
]}

set PipelineEnableSignalInfo {[
	{"Pipeline" : "0", "EnableSignal" : "ap_enable_pp0"}
]}

set Spec2ImplPortList { 
	x { ap_memory {  { x_address0 mem_address 1 10 }  { x_ce0 mem_ce 1 1 }  { x_q0 mem_dout 0 8 }  { x_address1 MemPortADDR2 1 10 }  { x_ce1 MemPortCE2 1 1 }  { x_q1 MemPortDOUT2 0 8 } } }
	p1 { ap_memory {  { p1_address0 mem_address 1 10 }  { p1_ce0 mem_ce 1 1 }  { p1_we0 mem_we 1 1 }  { p1_d0 mem_din 1 8 } } }
}

set maxi_interface_dict [dict create]

# RTL port scheduling information:
set fifoSchedulingInfoList { 
}

# RTL bus port read request latency information:
set busReadReqLatencyList { 
}

# RTL bus port write response latency information:
set busWriteResLatencyList { 
}

# RTL array port load latency information:
set memoryLoadLatencyList { 
}
