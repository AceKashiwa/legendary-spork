
Q
Command: %s
53*	vivadotcl2 
route_design2default:defaultZ4-113h px� 
�
@Attempting to get a license for feature '%s' and/or device '%s'
308*common2"
Implementation2default:default2"
xc7a35t-csg3242default:defaultZ17-347h px� 
�
0Got license for feature '%s' and/or device '%s'
310*common2"
Implementation2default:default2"
xc7a35t-csg3242default:defaultZ17-349h px� 
p
,Running DRC as a precondition to command %s
22*	vivadotcl2 
route_design2default:defaultZ4-22h px� 
w
Command: %s
53*	vivadotcl2F
2report_drc (run_mandatory_drcs) for: router_checks2default:defaultZ4-113h px� 
P
Running DRC with %s threads
24*drc2
22default:defaultZ23-27h px� 
�
�Placement Constraints Check for IO constraints: Partially locked IO Bus is found. Following components of the IO Bus %s are not locked:  %s%s*DRC2?
 ")
sw_pin[5:0]sw_pin2default:default2default:default2@
 "*
	sw_pin[5]	sw_pin[5]2default:default2default:default28
  DRC|Implementation|Placement|IOs2default:default8ZPLIO-3h px� 
q
%s completed successfully
29*	vivadotcl23
report_drc (run_mandatory_drcs)2default:defaultZ4-42h px� 
b
DRC finished with %s
79*	vivadotcl2(
0 Errors, 1 Warnings2default:defaultZ4-198h px� 
e
BPlease refer to the DRC report (report_drc) for more information.
80*	vivadotclZ4-199h px� 
V

Starting %s Task
103*constraints2
Routing2default:defaultZ18-103h px� 
}
BMultithreading enabled for route_design using a maximum of %s CPUs17*	routeflow2
22default:defaultZ35-254h px� 
p

Phase %s%s
101*constraints2
1 2default:default2#
Build RT Design2default:defaultZ18-101h px� 
B
-Phase 1 Build RT Design | Checksum: e508d63f
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:00:29 ; elapsed = 00:00:27 . Memory (MB): peak = 1148.984 ; gain = 108.3592default:defaulth px� 
v

Phase %s%s
101*constraints2
2 2default:default2)
Router Initialization2default:defaultZ18-101h px� 
o

Phase %s%s
101*constraints2
2.1 2default:default2 
Create Timer2default:defaultZ18-101h px� 
A
,Phase 2.1 Create Timer | Checksum: e508d63f
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:00:29 ; elapsed = 00:00:27 . Memory (MB): peak = 1148.984 ; gain = 108.3592default:defaulth px� 
{

Phase %s%s
101*constraints2
2.2 2default:default2,
Fix Topology Constraints2default:defaultZ18-101h px� 
M
8Phase 2.2 Fix Topology Constraints | Checksum: e508d63f
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:00:29 ; elapsed = 00:00:28 . Memory (MB): peak = 1148.984 ; gain = 108.3592default:defaulth px� 
t

Phase %s%s
101*constraints2
2.3 2default:default2%
Pre Route Cleanup2default:defaultZ18-101h px� 
F
1Phase 2.3 Pre Route Cleanup | Checksum: e508d63f
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:00:29 ; elapsed = 00:00:28 . Memory (MB): peak = 1148.984 ; gain = 108.3592default:defaulth px� 
p

Phase %s%s
101*constraints2
2.4 2default:default2!
Update Timing2default:defaultZ18-101h px� 
C
.Phase 2.4 Update Timing | Checksum: 1f64ec6a2
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:00:30 ; elapsed = 00:00:29 . Memory (MB): peak = 1148.984 ; gain = 108.3592default:defaulth px� 
�
Intermediate Timing Summary %s164*route2J
6| WNS=5.448  | TNS=0.000  | WHS=-0.339 | THS=-14.626|
2default:defaultZ35-416h px� 
}

Phase %s%s
101*constraints2
2.5 2default:default2.
Update Timing for Bus Skew2default:defaultZ18-101h px� 
r

Phase %s%s
101*constraints2
2.5.1 2default:default2!
Update Timing2default:defaultZ18-101h px� 
E
0Phase 2.5.1 Update Timing | Checksum: 1c19c7c81
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:00:30 ; elapsed = 00:00:29 . Memory (MB): peak = 1148.984 ; gain = 108.3592default:defaulth px� 
�
Intermediate Timing Summary %s164*route2J
6| WNS=5.448  | TNS=0.000  | WHS=N/A    | THS=N/A    |
2default:defaultZ35-416h px� 
P
;Phase 2.5 Update Timing for Bus Skew | Checksum: 1c71e511a
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:00:30 ; elapsed = 00:00:29 . Memory (MB): peak = 1180.848 ; gain = 140.2232default:defaulth px� 
I
4Phase 2 Router Initialization | Checksum: 142d45ad2
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:00:30 ; elapsed = 00:00:29 . Memory (MB): peak = 1180.848 ; gain = 140.2232default:defaulth px� 
p

Phase %s%s
101*constraints2
3 2default:default2#
Initial Routing2default:defaultZ18-101h px� 
C
.Phase 3 Initial Routing | Checksum: 19238fd11
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:00:30 ; elapsed = 00:00:29 . Memory (MB): peak = 1180.848 ; gain = 140.2232default:defaulth px� 
s

Phase %s%s
101*constraints2
4 2default:default2&
Rip-up And Reroute2default:defaultZ18-101h px� 
u

Phase %s%s
101*constraints2
4.1 2default:default2&
Global Iteration 02default:defaultZ18-101h px� 
�
Intermediate Timing Summary %s164*route2J
6| WNS=5.092  | TNS=0.000  | WHS=N/A    | THS=N/A    |
2default:defaultZ35-416h px� 
G
2Phase 4.1 Global Iteration 0 | Checksum: e9048f20
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:00:31 ; elapsed = 00:00:30 . Memory (MB): peak = 1180.848 ; gain = 140.2232default:defaulth px� 
E
0Phase 4 Rip-up And Reroute | Checksum: e9048f20
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:00:31 ; elapsed = 00:00:30 . Memory (MB): peak = 1180.848 ; gain = 140.2232default:defaulth px� 
|

Phase %s%s
101*constraints2
5 2default:default2/
Delay and Skew Optimization2default:defaultZ18-101h px� 
p

Phase %s%s
101*constraints2
5.1 2default:default2!
Delay CleanUp2default:defaultZ18-101h px� 
r

Phase %s%s
101*constraints2
5.1.1 2default:default2!
Update Timing2default:defaultZ18-101h px� 
E
0Phase 5.1.1 Update Timing | Checksum: 10fed93fd
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:00:31 ; elapsed = 00:00:30 . Memory (MB): peak = 1180.848 ; gain = 140.2232default:defaulth px� 
�
Intermediate Timing Summary %s164*route2J
6| WNS=5.172  | TNS=0.000  | WHS=N/A    | THS=N/A    |
2default:defaultZ35-416h px� 
B
-Phase 5.1 Delay CleanUp | Checksum: f7ff435a
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:00:31 ; elapsed = 00:00:30 . Memory (MB): peak = 1180.848 ; gain = 140.2232default:defaulth px� 
z

Phase %s%s
101*constraints2
5.2 2default:default2+
Clock Skew Optimization2default:defaultZ18-101h px� 
L
7Phase 5.2 Clock Skew Optimization | Checksum: f7ff435a
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:00:31 ; elapsed = 00:00:30 . Memory (MB): peak = 1180.848 ; gain = 140.2232default:defaulth px� 
N
9Phase 5 Delay and Skew Optimization | Checksum: f7ff435a
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:00:31 ; elapsed = 00:00:30 . Memory (MB): peak = 1180.848 ; gain = 140.2232default:defaulth px� 
n

Phase %s%s
101*constraints2
6 2default:default2!
Post Hold Fix2default:defaultZ18-101h px� 
p

Phase %s%s
101*constraints2
6.1 2default:default2!
Hold Fix Iter2default:defaultZ18-101h px� 
r

Phase %s%s
101*constraints2
6.1.1 2default:default2!
Update Timing2default:defaultZ18-101h px� 
E
0Phase 6.1.1 Update Timing | Checksum: 12729e5d5
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:00:31 ; elapsed = 00:00:30 . Memory (MB): peak = 1180.848 ; gain = 140.2232default:defaulth px� 
�
Intermediate Timing Summary %s164*route2J
6| WNS=5.172  | TNS=0.000  | WHS=0.062  | THS=0.000  |
2default:defaultZ35-416h px� 
C
.Phase 6.1 Hold Fix Iter | Checksum: 13765ead0
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:00:31 ; elapsed = 00:00:30 . Memory (MB): peak = 1180.848 ; gain = 140.2232default:defaulth px� 
A
,Phase 6 Post Hold Fix | Checksum: 13765ead0
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:00:31 ; elapsed = 00:00:30 . Memory (MB): peak = 1180.848 ; gain = 140.2232default:defaulth px� 
o

Phase %s%s
101*constraints2
7 2default:default2"
Route finalize2default:defaultZ18-101h px� 
B
-Phase 7 Route finalize | Checksum: 1934dff74
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:00:31 ; elapsed = 00:00:30 . Memory (MB): peak = 1180.848 ; gain = 140.2232default:defaulth px� 
v

Phase %s%s
101*constraints2
8 2default:default2)
Verifying routed nets2default:defaultZ18-101h px� 
I
4Phase 8 Verifying routed nets | Checksum: 1934dff74
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:00:31 ; elapsed = 00:00:30 . Memory (MB): peak = 1180.848 ; gain = 140.2232default:defaulth px� 
r

Phase %s%s
101*constraints2
9 2default:default2%
Depositing Routes2default:defaultZ18-101h px� 
E
0Phase 9 Depositing Routes | Checksum: 1b6db27e9
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:00:31 ; elapsed = 00:00:30 . Memory (MB): peak = 1180.848 ; gain = 140.2232default:defaulth px� 
t

Phase %s%s
101*constraints2
10 2default:default2&
Post Router Timing2default:defaultZ18-101h px� 
�
Estimated Timing Summary %s
57*route2J
6| WNS=5.172  | TNS=0.000  | WHS=0.062  | THS=0.000  |
2default:defaultZ35-57h px� 
�
�The final timing numbers are based on the router estimated timing analysis. For a complete and accurate timing signoff, please run report_timing_summary.
127*routeZ35-327h px� 
G
2Phase 10 Post Router Timing | Checksum: 1b6db27e9
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:00:31 ; elapsed = 00:00:30 . Memory (MB): peak = 1180.848 ; gain = 140.2232default:defaulth px� 
@
Router Completed Successfully
2*	routeflowZ35-16h px� 
�

%s
*constraints2q
]Time (s): cpu = 00:00:31 ; elapsed = 00:00:30 . Memory (MB): peak = 1180.848 ; gain = 140.2232default:defaulth px� 
�
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
632default:default2
232default:default2
02default:default2
02default:defaultZ4-41h px� 
^
%s completed successfully
29*	vivadotcl2 
route_design2default:defaultZ4-42h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2"
route_design: 2default:default2
00:00:342default:default2
00:00:322default:default2
1180.8482default:default2
140.2232default:defaultZ17-268h px� 
D
Writing placer database...
1603*designutilsZ20-1893h px� 
=
Writing XDEF routing.
211*designutilsZ20-211h px� 
J
#Writing XDEF routing logical nets.
209*designutilsZ20-209h px� 
J
#Writing XDEF routing special nets.
210*designutilsZ20-210h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2)
Write XDEF Complete: 2default:default2
00:00:002default:default2 
00:00:00.1932default:default2
1180.8482default:default2
0.0002default:defaultZ17-268h px� 
�
 The %s '%s' has been generated.
621*common2

checkpoint2default:default2H
4E:/w1/bt_uart/bt_uart.runs/impl_1/bt_uart_routed.dcp2default:defaultZ17-1381h px� 
�
Command: %s
53*	vivadotcl2q
]report_drc -file bt_uart_drc_routed.rpt -pb bt_uart_drc_routed.pb -rpx bt_uart_drc_routed.rpx2default:defaultZ4-113h px� 
P
Running DRC with %s threads
24*drc2
22default:defaultZ23-27h px� 
�
#The results of DRC are in file %s.
168*coretcl2�
8E:/w1/bt_uart/bt_uart.runs/impl_1/bt_uart_drc_routed.rpt8E:/w1/bt_uart/bt_uart.runs/impl_1/bt_uart_drc_routed.rpt2default:default8Z2-168h px� 
\
%s completed successfully
29*	vivadotcl2

report_drc2default:defaultZ4-42h px� 
�
Command: %s
53*	vivadotcl2w
creport_methodology -file bt_uart_methodology_drc_routed.rpt -rpx bt_uart_methodology_drc_routed.rpx2default:defaultZ4-113h px� 
E
%Done setting XDC timing constraints.
35*timingZ38-35h px� 
Y
$Running Methodology with %s threads
74*drc2
22default:defaultZ23-133h px� 
�
2The results of Report Methodology are in file %s.
450*coretcl2�
DE:/w1/bt_uart/bt_uart.runs/impl_1/bt_uart_methodology_drc_routed.rptDE:/w1/bt_uart/bt_uart.runs/impl_1/bt_uart_methodology_drc_routed.rpt2default:default8Z2-1520h px� 
d
%s completed successfully
29*	vivadotcl2&
report_methodology2default:defaultZ4-42h px� 
�
Command: %s
53*	vivadotcl2�
mreport_power -file bt_uart_power_routed.rpt -pb bt_uart_power_summary_routed.pb -rpx bt_uart_power_routed.rpx2default:defaultZ4-113h px� 
E
%Done setting XDC timing constraints.
35*timingZ38-35h px� 
K
,Running Vector-less Activity Propagation...
51*powerZ33-51h px� 
P
3
Finished Running Vector-less Activity Propagation
1*powerZ33-1h px� 
�
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
702default:default2
232default:default2
02default:default2
02default:defaultZ4-41h px� 
^
%s completed successfully
29*	vivadotcl2 
report_power2default:defaultZ4-42h px� 
r
UpdateTimingParams:%s.
91*timing29
% Speed grade: -1, Delay Type: min_max2default:defaultZ38-91h px� 
|
CMultithreading enabled for timing update using a maximum of %s CPUs155*timing2
22default:defaultZ38-191h px� 
�
}There are set_bus_skew constraint(s) in this design. Please run report_bus_skew to ensure that bus skew requirements are met.223*timingZ38-436h px� 


End Record