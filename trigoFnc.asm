sign_check8b macro sign
	push ax
	mov ah, 0 
	mov al, sign
	push ax
	call update_sign
	pop ax
endm
substructer_sinShort proc
	push cx
	push saver
	push powerd_angel
	call substructor ;; checking substructor.
	pop saver
	pop cx
	mov isNeg_calc, cl
	pop cx
	ret
substructer_sinShort endp

print_calc_current proc
	push ax
	mov ax, saver
	mov result, ax
	pop ax
	safe_calling print_result
	call downLine
	ret
print_calc_current endp
print_calc_pivot proc
	push cx
	mov ch, 0
	mov cl, pivot
	mov result, cx
	pop cx
	safe_calling print_result
	call downLine
	ret
print_calc_pivot endp
sin proc ;; sign check in the end?
	cmp angel, 0
	jnz sin_start
	mov result, 0
	mov isNeg_calc, 0
	mover8b isNeg_result, 0
	ret
	sin_start: 
	call fiting_pi_calc ;; seems to work
	mov cx, angel
	mov bl, pivot
	;mov saver, cx
	mover saver, angel
	;call print_calc_current
	mov cx, 3
	push cx
	call power_angel ;; didn't seem to work, getting 0.3.88 instead of 3.87
	push ax
	mov ax, powerd_angel
	pop ax
	divider powerd_angel, 6 ;doesn't curropt angel;; seems to work fine
	mov powerd_angel, ax
	call substructer_sinShort
	push ax
	mov ax, result
	pop ax
	;call print_calc_current
	mov cx, 5
	push cx
	call power_angel
	divider powerd_angel, 120
	mov powerd_angel, ax
	cmp isNeg_calc, 1
	jz negative_Sin5
	adder saver, powerd_angel
	push ax
	mov ax, result
	pop ax
	jmp continue_Sin7
	negative_Sin5:  ;checks if it needs to add them together in absulote value or substruct
		call substructer_sinShort
		push ax
		mov ax, result
		pop ax
		;;call print_calc_current
continue_Sin7:
	mov cx, 7
	push cx
	call power_angel
	divider32 powerd_angel, 5040 ;; here the risk of getting out of the 16 bit is high
	mov powerd_angel, ax
	cmp isNeg_calc, 1
	jz negative_Sin7  
	call substructer_sinShort
	jmp finish_sin
	negative_Sin7: ;same here
		adder saver, powerd_angel ;should it substruct if the signs are oppisite? i switched, lets see.
 finish_sin:
	mover result, saver
	mover8b isNeg_result, isNeg_calc
	push cx ; stores value
	mov cl, Larger_Than_1_sin
	mov ch, 0
	push cx ; input
	call update_sign
	mov cl, sign_betweenHalfOne_sin
	push cx
	call update_sign
	pop cx ; returns to original value
	ret
sin endp

cos proc
	mover angel, angel_cos
	mover8b sign_betweenHalfOne_sin, sign_betweenHalfOne_cos
	mover8b Larger_Than_1_sin, Larger_Than_1_cos
	call sin
	ret
cos endp

tan proc
	call sin
	mover sin_result, result
	mov result, 0
	mover8b isNeg_save, isNeg_result
	mover angel, angel_cos
	mover8b Larger_Than_1_sin, Larger_Than_1_cos
	mover8b sign_betweenHalfOne_sin, sign_betweenHalfOne_cos
	call sin
	cmp result, 6
	jnc continue_tan
	mov result, 65535
	compare8b isNeg_save, isNeg_result
	jz positive_result
	mov isNeg_result, 1
	jmp end_tan
continue_tan:
	call power_10
	mult32 sin_result, bx ;; makes absulote calc correct
	;mult32 sin_result, bx ;; moves to right base
	divider32 sin_result, result
	mov result, ax
	compare8b isNeg_save, isNeg_result
	jz positive_result
	mov isNeg_result, 1
	jmp end_tan
	positive_result: 
		mov isNeg_result, 0
end_tan: ret
tan endp