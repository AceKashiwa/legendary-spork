/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                         */
/*  \   \        Copyright (c) 2003-2013 Xilinx, Inc.                 */
/*  /   /        All Right Reserved.                                  */
/* /---/   /\                                                         */
/* \   \  /  \                                                        */
/*  \___\/\___\                                                       */
/**********************************************************************/


#include "iki.h"
#include <string.h>
#include <math.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                         */
/*  \   \        Copyright (c) 2003-2013 Xilinx, Inc.                 */
/*  /   /        All Right Reserved.                                  */
/* /---/   /\                                                         */
/* \   \  /  \                                                        */
/*  \___\/\___\                                                       */
/**********************************************************************/


#include "iki.h"
#include <string.h>
#include <math.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
typedef void (*funcp)(char *, char *);
extern int main(int, char**);
extern void vlog_simple_process_execute_0_fast_no_reg_no_agg(char*, char*, char*);
extern void execute_376(char*, char *);
extern void execute_377(char*, char *);
extern void execute_126(char*, char *);
extern void execute_127(char*, char *);
extern void execute_140(char*, char *);
extern void execute_354(char*, char *);
extern void execute_114(char*, char *);
extern void execute_116(char*, char *);
extern void execute_124(char*, char *);
extern void execute_131(char*, char *);
extern void execute_134(char*, char *);
extern void execute_146(char*, char *);
extern void execute_148(char*, char *);
extern void execute_150(char*, char *);
extern void execute_152(char*, char *);
extern void execute_157(char*, char *);
extern void execute_160(char*, char *);
extern void execute_164(char*, char *);
extern void execute_166(char*, char *);
extern void execute_168(char*, char *);
extern void execute_170(char*, char *);
extern void execute_351(char*, char *);
extern void execute_352(char*, char *);
extern void execute_185(char*, char *);
extern void execute_189(char*, char *);
extern void execute_187(char*, char *);
extern void execute_191(char*, char *);
extern void execute_196(char*, char *);
extern void execute_199(char*, char *);
extern void execute_202(char*, char *);
extern void execute_205(char*, char *);
extern void execute_208(char*, char *);
extern void execute_210(char*, char *);
extern void execute_211(char*, char *);
extern void execute_212(char*, char *);
extern void execute_217(char*, char *);
extern void execute_220(char*, char *);
extern void execute_222(char*, char *);
extern void execute_226(char*, char *);
extern void execute_228(char*, char *);
extern void execute_234(char*, char *);
extern void execute_265(char*, char *);
extern void execute_266(char*, char *);
extern void execute_268(char*, char *);
extern void execute_260(char*, char *);
extern void execute_241(char*, char *);
extern void execute_244(char*, char *);
extern void execute_247(char*, char *);
extern void execute_250(char*, char *);
extern void execute_253(char*, char *);
extern void execute_259(char*, char *);
extern void execute_255(char*, char *);
extern void execute_256(char*, char *);
extern void execute_257(char*, char *);
extern void execute_271(char*, char *);
extern void execute_273(char*, char *);
extern void execute_379(char*, char *);
extern void execute_362(char*, char *);
extern void execute_363(char*, char *);
extern void execute_383(char*, char *);
extern void execute_384(char*, char *);
extern void execute_366(char*, char *);
extern void execute_367(char*, char *);
extern void execute_368(char*, char *);
extern void execute_369(char*, char *);
extern void vlog_const_rhs_process_execute_0_fast_no_reg_no_agg(char*, char*, char*);
extern void execute_381(char*, char *);
extern void execute_382(char*, char *);
extern void execute_371(char*, char *);
extern void execute_372(char*, char *);
extern void execute_373(char*, char *);
extern void execute_385(char*, char *);
extern void execute_386(char*, char *);
extern void execute_387(char*, char *);
extern void execute_388(char*, char *);
extern void execute_389(char*, char *);
extern void vlog_transfunc_eventcallback(char*, char*, unsigned, unsigned, unsigned, char *);
extern void transaction_5(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_7(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_12(char*, char*, unsigned, unsigned, unsigned);
extern void vhdl_transfunc_eventcallback(char*, char*, unsigned, unsigned, unsigned, char *);
funcp funcTab[82] = {(funcp)vlog_simple_process_execute_0_fast_no_reg_no_agg, (funcp)execute_376, (funcp)execute_377, (funcp)execute_126, (funcp)execute_127, (funcp)execute_140, (funcp)execute_354, (funcp)execute_114, (funcp)execute_116, (funcp)execute_124, (funcp)execute_131, (funcp)execute_134, (funcp)execute_146, (funcp)execute_148, (funcp)execute_150, (funcp)execute_152, (funcp)execute_157, (funcp)execute_160, (funcp)execute_164, (funcp)execute_166, (funcp)execute_168, (funcp)execute_170, (funcp)execute_351, (funcp)execute_352, (funcp)execute_185, (funcp)execute_189, (funcp)execute_187, (funcp)execute_191, (funcp)execute_196, (funcp)execute_199, (funcp)execute_202, (funcp)execute_205, (funcp)execute_208, (funcp)execute_210, (funcp)execute_211, (funcp)execute_212, (funcp)execute_217, (funcp)execute_220, (funcp)execute_222, (funcp)execute_226, (funcp)execute_228, (funcp)execute_234, (funcp)execute_265, (funcp)execute_266, (funcp)execute_268, (funcp)execute_260, (funcp)execute_241, (funcp)execute_244, (funcp)execute_247, (funcp)execute_250, (funcp)execute_253, (funcp)execute_259, (funcp)execute_255, (funcp)execute_256, (funcp)execute_257, (funcp)execute_271, (funcp)execute_273, (funcp)execute_379, (funcp)execute_362, (funcp)execute_363, (funcp)execute_383, (funcp)execute_384, (funcp)execute_366, (funcp)execute_367, (funcp)execute_368, (funcp)execute_369, (funcp)vlog_const_rhs_process_execute_0_fast_no_reg_no_agg, (funcp)execute_381, (funcp)execute_382, (funcp)execute_371, (funcp)execute_372, (funcp)execute_373, (funcp)execute_385, (funcp)execute_386, (funcp)execute_387, (funcp)execute_388, (funcp)execute_389, (funcp)vlog_transfunc_eventcallback, (funcp)transaction_5, (funcp)transaction_7, (funcp)transaction_12, (funcp)vhdl_transfunc_eventcallback};
const int NumRelocateId= 82;

void relocate(char *dp)
{
	iki_relocate(dp, "xsim.dir/counter_wrapper_behav/xsim.reloc",  (void **)funcTab, 82);
	iki_vhdl_file_variable_register(dp + 38352);
	iki_vhdl_file_variable_register(dp + 38408);


	/*Populate the transaction function pointer field in the whole net structure */
}

void sensitize(char *dp)
{
	iki_sensitize(dp, "xsim.dir/counter_wrapper_behav/xsim.reloc");
}

void simulate(char *dp)
{
	iki_schedule_processes_at_time_zero(dp, "xsim.dir/counter_wrapper_behav/xsim.reloc");
	// Initialize Verilog nets in mixed simulation, for the cases when the value at time 0 should be propagated from the mixed language Vhdl net

	iki_vlog_schedule_transaction_signal_fast_vhdl_value_time_0(dp + 44832, dp + 43504, 0, 15, 0, 15, 16, 1);
	iki_execute_processes();

	// Schedule resolution functions for the multiply driven Verilog nets that have strength
	// Schedule transaction functions for the singly driven Verilog nets that have strength

}
#include "iki_bridge.h"
void relocate(char *);

void sensitize(char *);

void simulate(char *);

int main(int argc, char **argv)
{
    iki_heap_initialize("ms", "isimmm", 0, 2147483648) ;
    iki_set_sv_type_file_path_name("xsim.dir/counter_wrapper_behav/xsim.svtype");
    iki_set_crvs_dump_file_path_name("xsim.dir/counter_wrapper_behav/xsim.crvsdump");
    void* design_handle = iki_create_design("xsim.dir/counter_wrapper_behav/xsim.mem", (void *)relocate, (void *)sensitize, (void *)simulate, 0, isimBridge_getWdbWriter(), 0, argc, argv);
     iki_set_rc_trial_count(100);
    (void) design_handle;
    return iki_simulate_design();
}
