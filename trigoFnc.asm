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
	call substructor
	pop saver
	pop cx
	mov isNeg_calc, cl
	pop cx
	ret
substructer_sinShort endp


sin proc
	call fiting_pi_calc
	mov cx, angel
	mov bl, pivot
	mov saver, cx
	mov cx, 3
	push cx
	call power_angel
	divider powerd_angel, 6
	call substructer_sinShort
	mov cx, 5
	push cx
	call power_angel
	divider powerd_angel, 120
	cmp isNeg_calc, 1
	jz negative_Sin5
	adder saver, powerd_angel
	jmp continue_Sin7
	negative_Sin5: 
		call substructer_sinShort
continue_Sin7:
	mov cx, 7
	push cx
	call power_angel
	divider powerd_angel, 5040
	cmp isNeg_calc, 1
	jz negative_Sin7
	adder saver, powerd_angel
	jmp finish_sin
	negative_Sin7:
		call substructer_sinShort
 finish_sin:
	mover result, saver
	mover8b isNeg_result, isNeg_calc
	ret
sin endp

cos proc
	mover angel, angel_cos
	call sin
	ret
cos endp

tan proc
	call sin
	mover sin_result, result
	mover8b isNeg_save, isNeg_result
	mover angel, angel_cos
	call sin
	divider result, sin_result
	mov result, ax
	compare8b isNeg_save, isNeg_result
	jz positive_result
	mov isNeg_result, 1
	jmp end_tan
	positive_result: 
		mov isNeg_result, 0
end_tan: ret
tan endp