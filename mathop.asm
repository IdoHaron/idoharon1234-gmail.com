mult macro num1, num2 ; returns result in num1, can't be ax or dx
	push dx
	push ax
	push cx
	mov ax, num1
	mov cx, num2
	mul cx
	pop cx
	mov num1, ax
	pop ax
	pop dx
endm

subFrom1 macro
		push bx
		call power_10
		sub bx, ax
		mov ax, bx
		pop bx
endm

divider macro num1, num2 ; result returns in ax ; doesn't cahnge num1
	push bx
	push dx 
	mov dx, 0
	mov ax, num1
	mov bx, num2
	div bx
	pop dx
	pop bx
endm

adder macro num1, num2
	push ax
	push bx
	mov ax, num1
	mov bx, num2
	add ax, bx
	mov num1, ax
	pop bx
	pop ax
endm

compare8b macro num1, num2
	push ax
	mov al, num1
	mov ah, num2
	cmp al, ah
	pop ax
endm

mover macro num1, num2
	push ax
	mov ax, num2
	mov num1, ax
	pop ax
endm

mover8b macro num1, num2
	push ax
	mov al, num2
	mov num1, al
	pop ax
endm

power_10 proc ; result in bx, doesn't recieve nothing
	push cx
	mov cx, 0
	mov cl, pivot
	mov bx, 1
	power_10_mul: mult bx, 10
	mov ah, ah
	mov al, al
	loop power_10_mul
	pop cx
	ret
power_10 endp


half_pivot_CALC proc
	push ax
	push bx
	push dx
	push cx
	mov bh, 0
	mov bl, pivot
	divider bx, 2
	mov half_pivot, al
	pop cx
	pop dx
	pop bx
	pop ax
half_pivot_CALC endp

substructor proc ;; substruct two values from stuck; first pop is the substructor the second pop is the substructed; result saved in stuck, first pop and the sign second pop
	pop dx
	pop bx
	pop ax
	cmp ax, bx
	jc negative_result
	mov cx, 0
	push cx
	sub ax, bx
	push ax
	push dx
	ret
	negative_result:
		mov cx, 1
		push cx 
		sub bx, ax
		push bx
		push dx
		ret
substructor endp

angel_manager proc ;; fixes everything to the 2 round, but not to 1, this needs more programing. 
	mov cx, 2
	call power_10
	mult cx, bx
	push cx
	mov dx, 0 
	mov ax, angel
	div cx
	mov angel, dx
	mov angel_cos, dx ;; does this part fine.
	mov cx, 5 ;; 1.5, so we need to divide by 10 the pivot
	divider bx, 10 ;; here it breaks, the problem is val/val throws the div of.
	mov bx, ax
	mult cx, bx
	add dx, cx ;;
	mov ax, dx
	mov dx, 0
	pop cx ;; the 2pi value
	div cx
	mov angel_cos, dx ;; puts the reminder in 
	ret
angel_manager endp 

fiting_pi_calc proc
	push bx 
	push ax
	push cx
	call power_10
	divider bx, 100 ; result in ax
	mov div_savr, ax
	mov bx, 314
	mult bx, div_savr
	mult angel, bx  
	call power_10
	divider angel, bx
	mov angel, ax
	pop cx
	pop ax
	pop bx
	ret
fiting_pi_calc endp

larger_than_pi proc ; check that it is not seppoused to also substruct the full value from the sign
	mov ax, angel
	mov cx,cx
	mov ax, ax
	mov sign_betweenHalfOne_sin, 0
	mov sign_betweenHalfOne_cos, 0 ;; assignments.
	call power_10;;
	call power10_div2
	cmp ax, bx
	jc larger_than_pi_false_angel
	mov Larger_Than_1_sin, 1
	sub ax, bx
	mov angel, ax
	jmp angel_cos_larger_than
	larger_than_pi_false_angel:
		mov Larger_Than_1_sin, 0
		
		cmp ax, cx
		jc  angel_cos_larger_than
		mov sign_betweenHalfOne_sin, 0
		subFrom1
		mov angel, ax
	angel_cos_larger_than:
		mov ax, angel_cos
		cmp ax, bx
		jc larger_than_pi_false_angel_cos
		mov Larger_Than_1_cos, 1
		sub ax, bx
		;;
		cmp ax, cx
		jmp cos_halfAngel
		;;
		larger_than_pi_false_angel_cos:
			mov Larger_Than_1_cos, 0
		cos_halfAngel:
			cmp ax, cx
			jc  end_larger_pi
			mov sign_betweenHalfOne_cos, 0
			subFrom1
	end_larger_pi:
		mov angel_cos, ax
		ret
larger_than_pi endp

power10_div2 proc
	push ax
	push bx
	call power_10
	divider bx, 2
	mov cx, ax
	pop bx
	pop ax
	ret
power10_div2 endp
update_sign proc ; recieves one sign from stack the other is in isNeg_result
	pop dx
	pop cx
	push dx ; adress
	cmp cl, isNeg_result
	jz	_posEnd
	mov isNeg_result, 1
	jmp end_updateSign
	_posEnd:
		mov isNeg_result, 0
	end_updateSign: ret
update_sign endp

fixPivot proc
	mov ax, angel
	mov cx, 10
	mov bl, pivot
	cmp pivot, 2
	jc small_ficPivot
	jnz fix_pivot_bigger
	ret
	fix_pivot_bigger:
		cmp bl, 2
		jz end_fix_pivot
		sub bl, 1
		div cx
		cmp dx, 5
		jc fix_pivot_bigger ;; if not need to enlarge angel
		add ax, 6
		jmp fix_pivot_bigger
	small_ficPivot:
		cmp bl, 2
		jz end_fix_pivot
		add bl, 1
		mul cx
		jmp small_ficPivot
	end_fix_pivot:
		mov pivot, bl
		mov angel, ax
		call half_pivot_CALC
		ret
fixPivot endp