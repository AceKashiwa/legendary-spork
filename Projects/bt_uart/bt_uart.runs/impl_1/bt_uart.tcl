proc start_step { step } {
  set stopFile ".stop.rst"
  if {[file isfile .stop.rst]} {
    puts ""
    puts "*** Halting run - EA reset detected ***"
    puts ""
    puts ""
    return -code error
  }
  set beginFile ".$step.begin.rst"
  set platform "$::tcl_platform(platform)"
  set user "$::tcl_platform(user)"
  set pid [pid]
  set host ""
  if { [string equal $platform unix] } {
    if { [info exist ::env(HOSTNAME)] } {
      set host $::env(HOSTNAME)
    }
  } else {
    if { [info exist ::env(COMPUTERNAME)] } {
      set host $::env(COMPUTERNAME)
    }
  }
  set ch [open $beginFile w]
  puts $ch "<?xml version=\"1.0\"?>"
  puts $ch "<ProcessHandle Version=\"1\" Minor=\"0\">"
  puts $ch "    <Process Command=\".planAhead.\" Owner=\"$user\" Host=\"$host\" Pid=\"$pid\">"
  puts $ch "    </Process>"
  puts $ch "</ProcessHandle>"
  close $ch
}

proc end_step { step } {
  set endFile ".$step.end.rst"
  set ch [open $endFile w]
  close $ch
}

proc step_failed { step } {
  set endFile ".$step.error.rst"
  set ch [open $endFile w]
  close $ch
}


start_step init_design
set ACTIVE_STEP init_design
set rc [catch {
  create_msg_db init_design.pb
  create_project -in_memory -part xc7a35tcsg324-1
  set_property design_mode GateLvl [current_fileset]
  set_param project.singleFileAddWarning.threshold 0
  set_property webtalk.parent_dir E:/w1/bt_uart/bt_uart.cache/wt [current_project]
  set_property parent.project_path E:/w1/bt_uart/bt_uart.xpr [current_project]
  set_property ip_output_repo E:/w1/bt_uart/bt_uart.cache/ip [current_project]
  set_property ip_cache_permissions {read write} [current_project]
  set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]
  add_files -quiet E:/w1/bt_uart/bt_uart.runs/synth_1/bt_uart.dcp
  read_ip -quiet e:/w1/bt_uart/bt_uart.srcs/sources_1/ip/clk_core/clk_core.xci
  set_property is_locked true [get_files e:/w1/bt_uart/bt_uart.srcs/sources_1/ip/clk_core/clk_core.xci]
  read_ip -quiet e:/w1/bt_uart/bt_uart.srcs/sources_1/ip/char_fifo/char_fifo.xci
  set_property is_locked true [get_files e:/w1/bt_uart/bt_uart.srcs/sources_1/ip/char_fifo/char_fifo.xci]
  read_xdc E:/w1/bt_uart/bt_uart.srcs/constrs_1/new/bt_uart_EGo.xdc
  link_design -top bt_uart -part xc7a35tcsg324-1
  close_msg_db -file init_design.pb
} RESULT]
if {$rc} {
  step_failed init_design
  return -code error $RESULT
} else {
  end_step init_design
  unset ACTIVE_STEP 
}

start_step opt_design
set ACTIVE_STEP opt_design
set rc [catch {
  create_msg_db opt_design.pb
  opt_design 
  write_checkpoint -force bt_uart_opt.dcp
  catch { report_drc -file bt_uart_drc_opted.rpt }
  close_msg_db -file opt_design.pb
} RESULT]
if {$rc} {
  step_failed opt_design
  return -code error $RESULT
} else {
  end_step opt_design
  unset ACTIVE_STEP 
}

start_step place_design
set ACTIVE_STEP place_design
set rc [catch {
  create_msg_db place_design.pb
  implement_debug_core 
  place_design 
  write_checkpoint -force bt_uart_placed.dcp
  catch { report_io -file bt_uart_io_placed.rpt }
  catch { report_utilization -file bt_uart_utilization_placed.rpt -pb bt_uart_utilization_placed.pb }
  catch { report_control_sets -verbose -file bt_uart_control_sets_placed.rpt }
  close_msg_db -file place_design.pb
} RESULT]
if {$rc} {
  step_failed place_design
  return -code error $RESULT
} else {
  end_step place_design
  unset ACTIVE_STEP 
}

start_step route_design
set ACTIVE_STEP route_design
set rc [catch {
  create_msg_db route_design.pb
  route_design 
  write_checkpoint -force bt_uart_routed.dcp
  catch { report_drc -file bt_uart_drc_routed.rpt -pb bt_uart_drc_routed.pb -rpx bt_uart_drc_routed.rpx }
  catch { report_methodology -file bt_uart_methodology_drc_routed.rpt -rpx bt_uart_methodology_drc_routed.rpx }
  catch { report_power -file bt_uart_power_routed.rpt -pb bt_uart_power_summary_routed.pb -rpx bt_uart_power_routed.rpx }
  catch { report_route_status -file bt_uart_route_status.rpt -pb bt_uart_route_status.pb }
  catch { report_clock_utilization -file bt_uart_clock_utilization_routed.rpt }
  catch { report_timing_summary -warn_on_violation -max_paths 10 -file bt_uart_timing_summary_routed.rpt -rpx bt_uart_timing_summary_routed.rpx }
  close_msg_db -file route_design.pb
} RESULT]
if {$rc} {
  write_checkpoint -force bt_uart_routed_error.dcp
  step_failed route_design
  return -code error $RESULT
} else {
  end_step route_design
  unset ACTIVE_STEP 
}

start_step write_bitstream
set ACTIVE_STEP write_bitstream
set rc [catch {
  create_msg_db write_bitstream.pb
  set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]
  catch { write_mem_info -force bt_uart.mmi }
  write_bitstream -force bt_uart.bit 
  catch {write_debug_probes -no_partial_ltxfile -quiet -force debug_nets}
  catch {file copy -force debug_nets.ltx bt_uart.ltx}
  close_msg_db -file write_bitstream.pb
} RESULT]
if {$rc} {
  step_failed write_bitstream
  return -code error $RESULT
} else {
  end_step write_bitstream
  unset ACTIVE_STEP 
}

