//
// Author:
//   Christian Mueller <cmueller@ps.uni-sb.de>
//
// Copyright:
//   Christian Mueller, 2005
//
// Last Change:
//   $Date: 2006-04-24 08:33:39 $ by $Author: cmueller $
//   $Revision: 1.19 $
//

// instruction definition
// be careful that they are lexicographically ordered; otherwise the ByteCode
// Assembler won't work

// r -> register
// i -> immediate
// l(i|r) -> list
// <arglist> ::= [("r,")* ("i,"*) ("i,li"|"i,lr"|"li<digit>"|"lr<digit>"|"")]
//
// So in front of a variable length list lr|li there is an immediate 
// specifying the length of the list. Static lists have the size information
// included. 

INSTR(await)			// [r]
INSTR(bci_call) 		// [i,i,lr]
INSTR(bci_call0) 		// [i]
INSTR(bci_call1)		// [i,r]
INSTR(bci_call2)		// [i,r,r]
INSTR(bci_call3)		// [i,r,r,r]
INSTR(bci_tailcall)		// [i,i,lr]
INSTR(bci_tailcall0)		// [i]
INSTR(bci_tailcall1)		// [i,r]
INSTR(bci_tailcall2)		// [i,r,r]
INSTR(bci_tailcall3)		// [i,r,r,r]
INSTR(bigtagtest)		// [r,i]
INSTR(bigtagtest1)		// [r,i,i]
INSTR(cbigtagtest)		// [r,i,li]
INSTR(cbigtagtest_direct)       // [r,i,li]
INSTR(ccc1)			// []
INSTR(cccn)			// [i]   
INSTR(check_preempt_jump)	// [i]
INSTR(citest)			// [r,i,i,li]
INSTR(contest)			// [r,r,i]
INSTR(ctagtest)		        // [r,i,li]	
INSTR(ctagtest_direct)	   	// [r,i,li]
INSTR(debug_msg)		// [i]
INSTR(dummy_raiseoverflow)      // []
INSTR(get_arg0)		        // [r]	
INSTR(get_arg0_direct)	   	// []
INSTR(get_args)		        // [i]	
INSTR(get_args_direct)	   	// []
INSTR(get_tup2)		        // [r,r,r]	
INSTR(get_tup3)		        // [r,r,r,r]
INSTR(iadd)			// [r,r,r]
INSTR(idec)			// [r,r]
INSTR(iinc)			// [r,r]
INSTR(ijump_eq)		        // [r,i,i]	
INSTR(immediate_call)	   	// [i,i,lr]	
INSTR(immediate_call0)		// [i]
INSTR(immediate_call1)		// [r,i]
INSTR(immediate_call2)		// [r,r,i]
INSTR(immediate_call3)		// [r,r,r,i]
INSTR(immediate_tailcall)	// [i,i,lr]
INSTR(immediate_tailcall0)	// [i]
INSTR(immediate_tailcall1)	// [r,i]
INSTR(immediate_tailcall2)	// [r,r,i]	
INSTR(immediate_tailcall3)	// [r,r,r,i]
INSTR(init_bigtagval)		// [r,r,i]
INSTR(init_closure)		// [r,r,i]
INSTR(init_con)			// [r,r,i]
INSTR(init_polyrec)		// [r,r,i]
INSTR(init_tagval)		// [r,r,i]
INSTR(init_tup)		        // [r,r,i]	
INSTR(init_vec)		        // [r,r,i]
INSTR(inlined_future_byneed)	// [r,r]
INSTR(inlined_hole_fill)	// [r,r]
INSTR(inlined_hole_hole)	// [r]
INSTR(install_handler)		// [i]
INSTR(isub)			// [r,r,r]
INSTR(itest)			// [r,i]
INSTR(jump)			// [i]
INSTR(lazyselect_polyrec)	// [r,r,i]
INSTR(lazyselect_polyrec_n)	// [r,i,i]
INSTR(load_bigtagval)		// [r,r,i]
INSTR(load_bigtagval1)	        // [r,r]
INSTR(load_bigtagval2)	        // [r,r,r]
INSTR(load_bigtagval3)	        // [r,r,r,r]
INSTR(load_cell)		// [r,r]
INSTR(load_con)			// [r,r,i]
INSTR(load_global)		// [r,i]
INSTR(load_immediate)		// [r,i]
INSTR(load_int)			// [r,i]
INSTR(load_reg)			// [r,r]
INSTR(load_tagval)		// [r,r,i]
INSTR(load_tagval1)		// [r,r]
INSTR(load_tagval2)		// [r,r,r]
INSTR(load_tagval3)		// [r,r,r,r]
INSTR(load_vec)		        // [r,r,i]
INSTR(load_zero)		// [r]
INSTR(mk_closure)		// [r,i,i]
INSTR(new_bigtagval)		// [r,i,i]
INSTR(new_bigtagval_init)	// [r,i,i,lr]]
INSTR(new_bigtagval_init1)	// [r,i,lr1]
INSTR(new_bigtagval_init2)	// [r,i,lr2]
INSTR(new_bigtagval_init3)	// [r,i,lr3]
INSTR(new_bigtagval_init4)	// [r,i,lr4]
INSTR(new_cell)			// [r,r] 
INSTR(new_con)			// [r,i]
INSTR(new_pair)			// [r,r,r]
INSTR(new_polyrec)		// [r,i]
INSTR(new_tagval)		// [r,i,i]
INSTR(new_tagval_init)		// [r,i,i,lr]]
INSTR(new_tagval_init1)	        // [r,i,lr1]
INSTR(new_tagval_init2)	        // [r,i,lr2]
INSTR(new_tagval_init3)	        // [r,i,lr3]
INSTR(new_tagval_init4)	        // [r,i,lr4]
INSTR(new_triple)		// [r,r,r,r]
INSTR(new_tup)			// [r,i]
INSTR(new_vec)			// [r,i]
INSTR(prepare_con)		// [r,r,i]
INSTR(raise_direct)		// [r]
INSTR(raise_normal)		// [r]
INSTR(remove_handler)		// []
INSTR(rewrite_call)		// [i,i,lr]
INSTR(rewrite_call0)		// [i]
INSTR(rewrite_call1)		// [i,r]
INSTR(rewrite_call2)		// [i,r,r]
INSTR(rewrite_call3)		// [i,r,r,r]
INSTR(rewrite_tailcall)	        // [i,i,lr]
INSTR(rewrite_tailcall0)	// [i]
INSTR(rewrite_tailcall1)	// [i,r]
INSTR(rewrite_tailcall2)	// [i,r,r]
INSTR(rewrite_tailcall3)	// [i,r,r,r]
INSTR(rjump_eq)		        // [r,i,i]
INSTR(rtest)			// [r,i]
INSTR(seam_call)		// [r,i,lr]
INSTR(seam_call0)		// [r]
INSTR(seam_call1)		// [r,r]
INSTR(seam_call2)		// [r,r,r]
INSTR(seam_call3)		// [r,r,r,r]
INSTR(seam_ccc1)		// [r]
INSTR(seam_cccn)		// [i]
INSTR(seam_prim_call)		// [i,i,lr]
INSTR(seam_prim_call0)		// [i]
INSTR(seam_prim_call1)		// [i,r]
INSTR(seam_prim_call2)		// [i,r,r]
INSTR(seam_prim_call3)		// [i,r,r,r]
INSTR(seam_prim_tailcall)	// [i,i,lr]
INSTR(seam_prim_tailcall0)	// [i]
INSTR(seam_prim_tailcall1)	// [i,r]
INSTR(seam_prim_tailcall2)	// [i,r,r]
INSTR(seam_prim_tailcall3)	// [i,r,r,r]
INSTR(seam_return)		// [i,lr]
INSTR(seam_return0)		// []
INSTR(seam_return1)		// [r]
INSTR(seam_return2)		// [r,r]
INSTR(seam_return3)		// [r,r,r]
INSTR(seam_return_zero)         // []
INSTR(seam_tailcall)		// [r,i,lr]
INSTR(seam_tailcall0)		// [r]
INSTR(seam_tailcall1)		// [r,r]
INSTR(seam_tailcall2)		// [r,r,r]
INSTR(seam_tailcall3)		// [r,r,r,r]
INSTR(select_tup)		// [r,r,i]
INSTR(select_tup0)		// [r,r]
INSTR(select_tup1)		// [r,r]
INSTR(select_tup2)		// [r,r]
INSTR(self_call)		// [i,lr]
INSTR(self_call0)		// []
INSTR(self_call1)		// [r]
INSTR(self_call2)		// [r,r]
INSTR(self_call3)		// [r,r,r]
INSTR(set_cell)			// [r,r]
INSTR(set_global)		// [r,i]
INSTR(sjump_eq)		        // [r,i,i]
INSTR(spec_closure)		// [r,r,i,i]
INSTR(stest)			// [r,i]
INSTR(swap_regs)		// [r,r]
INSTR(tagtest)			// [r,i]
INSTR(tagtest1)		        // [r,i,i]
INSTR(vectest)			// [r,i]
