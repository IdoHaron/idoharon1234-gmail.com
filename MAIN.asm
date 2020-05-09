dseg segment
	angel dw 0 ;the angel
	div_savr dw 0 ; for the pi_mul
	powerd_angel dw 0 ;used in calc
	angel_cos dw 0; saves angel for cos calculation in tan
	Larger_Than_1_sin db 0 ;saves if the angel larger than π 1 if not
	Larger_Than_1_cos db 0 ;saves if the angel larger than π 1 if not
	sign_betweenHalfOne_sin db 0
	sign_betweenHalfOne_cos db 0
	saver dw 0 ; saves value for the calculation, there the result is saved.
	isNeg_calc db 0 ;  0 = the number is positive 1= negtive, during caclulation
	sin_result dw 0 ;saves sin result for tan calc
	result dw 0 ; saves the result
	isNeg_result db 0 ;  0 = the number is positive 1= negtive, result
	isNeg_save db 0;  0 = the number is positive 1= negtive, tan
	trigo_func db 0 ; func saver ( s = sin, c = cos, t = tan)
	pivot db 0 ; saves the pivot-point, the power of 10 you should divide to get the real number
	half_pivot db 0
	length_larger_than1 db 0 ; the number of larger than 1 including 1, like anti pivot.
	massage1 db "choose function (s= sin, c= cos, t=tan, e= end): $"
	massage2 db "enter rad angel, divided by pi: pi$"
	massage3 db "result:$"
	;not_full_numM db "0.$"
	inf db "infinity$"
dseg ends
cseg segment 
assume cs:cseg, ds: dseg
safe_calling macro lab
	push ax
	push bx
	push cx
	push dx
	call lab
	pop dx
	pop cx
	pop bx
	pop ax
endm
include mathop.asm
include Math32.asm
include print.asm
include input.asm
include trigoFnc.asm
	start:
		mov ax, dseg
		mov ds, ax
		mov pivot, 0
		print massage1
		call enter_char
		mov trigo_func, al
		call downLine
		print massage2
		mov cx, angel
		mov cx, angel_cos
		call enter_notFullPos
		call fixPivot ;moves everything to 2 decimal;;; works
		mov cl, pivot
		mov cl, Larger_Than_1_sin
		mov cl, sign_betweenHalfOne_sin
		mov cl, Larger_Than_1_cos
		mov cl, sign_betweenHalfOne_cos
		call angel_manager ; fixes everything to round 2, and creates angel_cos
		call larger_than_pi  ; saves if the cos angel or the sin angel are larger than π here is the problem on angel=0.5
		cmp trigo_func,  "s"
		jnz cos_tan
		call sin 
		mov ax, result
		;sign_check8b Larger_Than_1_sin
		jmp resultMain
		cos_tan:
			cmp trigo_func, "c"
			jnz tanMAIN
			call cos
			;sign_check8b Larger_Than_1_cos
			jmp resultMain
			tanMAIN:
			cmp trigo_func, "e"
			jz end_prog
			call tan ;tan is exactly the same in the ranges [0-1,1-2] pi
	resultMain:
		mov ax, result
		print massage3
		call print_result
		call enter_char
		jmp start
	end_prog:
		int 3h
cseg ends
end start