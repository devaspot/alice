val assert=General.assert;
(*
 * Author:
 *   Andreas Rossberg <rossberg@ps.uni-sb.de>
 *
 * Copyright:
 *   Andreas Rossberg, 2001
 *
 * Last change:
 *   $Date: 2007-04-02 14:43:48 $ by $Author: rossberg $
 *   $Revision: 1.12 $
 *)







structure AbstractInfo =
struct
    type fix_info	= Source.region
    type vallab_info	= Source.region
    type typlab_info	= Source.region
    type modlab_info	= Source.region
    type inflab_info	= Source.region
    type valid_info	= Source.region
    type typid_info	= Source.region
    type varid_info	= Source.region
    type modid_info	= Source.region
    type infid_info	= Source.region
    type vallongid_info	= Source.region
    type typlongid_info	= Source.region
    type modlongid_info	= Source.region
    type inflongid_info	= Source.region
    type exp_info	= Source.region
    type pat_info	= Source.region
    type 'a row_info	= Source.region
    type 'a fld_info	= Source.region
    type mat_info	= Source.region
    type typ_info	= Source.region
    type mod_info	= Source.region
    type inf_info	= Source.region
    type dec_info	= Source.region
    type spec_info	= Source.region
    type imp_info	= Source.region
    type ann_info	= Source.region
    type com_info	= Source.region
end

structure AbstractGrammar = MkAbstractGrammar(AbstractInfo)

structure PPAbstractGrammar = MkPPAbstractGrammar(
	structure AbstractGrammar = AbstractGrammar
	fun ppInfo((l,c), _)	= PrettyPrint.text
				   ("@" ^ Int.toString l ^ "." ^ Int.toString c)
	val ppFixInfo		= ppInfo
	val ppVallabInfo	= ppInfo
	val ppTyplabInfo	= ppInfo
	val ppModlabInfo	= ppInfo
	val ppInflabInfo	= ppInfo
	val ppValidInfo		= ppInfo
	val ppTypidInfo		= ppInfo
	val ppVaridInfo		= ppInfo
	val ppModidInfo		= ppInfo
	val ppInfidInfo		= ppInfo
	val ppVallongidInfo	= ppInfo
	val ppTyplongidInfo	= ppInfo
	val ppModlongidInfo	= ppInfo
	val ppInflongidInfo	= ppInfo
	val ppExpInfo		= ppInfo
	val ppPatInfo		= ppInfo
	val ppRowInfo		= fn _ => ppInfo
	val ppFldInfo		= fn _ => ppInfo
	val ppMatInfo		= ppInfo
	val ppTypInfo		= ppInfo
	val ppModInfo		= ppInfo
	val ppInfInfo		= ppInfo
	val ppDecInfo		= ppInfo
	val ppSpecInfo		= ppInfo
	val ppImpInfo		= ppInfo
	val ppAnnInfo		= ppInfo
	val ppComInfo		= ppInfo)
