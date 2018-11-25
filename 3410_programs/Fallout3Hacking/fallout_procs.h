.NOLIST
.386

EXTRN output_str_proc:Near32
EXTRN analyze_str_proc:Near32

analyze_array_matches MACRO array_name, length, num_strs, pw_index, char_matches, xtra
		IFB <array_name>
			.ERR <missing "array_name" operand in analyze_array_matches>
		ELSEIFB <length>
			.ERR <missing "length" operand in analyze_array_matches>
		ELSEIFB <num_strs>
			.ERR <missing "num_strs" operand in analyze_array_matches>
		ELSEIFB <pw_index>
			.ERR <missing "pw_index" operand in analyze_array_matches>
		ELSEIFB <char_matches>
			.ERR <missing "char_matches" operand in analyze_array_matches>
		ELSEIFNB <xtra>
			.ERR <extra operand(s) in analyze_array_matches>
		ELSE
		lea ebx, array_name
		push ebx
		push length
		push num_strs
		push pw_index
		push char_matches
		call analyze_str_proc
		ENDIF
	ENDM

output_str_array MACRO array_name, length, num_strs, xtra
		IFB <array_name>
			.ERR <missing "array_name" operand in output_str_proc>
		ELSEIFB <length>
			.ERR <missing "length" operand in output_str_proc>
		ELSEIFB <num_strs>
			.ERR <missing "num_strs" operand in output_str_proc>
		ELSEIFNB <xtra>
			.ERR <extra operand(s) in output_str_proc>
		ELSE
		lea ebx, array_name
		push ebx
		push length
		push num_strs
		call output_str_proc
		ENDIF
	ENDM