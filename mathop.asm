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
	cmp al, bh
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

power_angel proc ;; multiplayes the angel ;; recieves the power in the stack ;; returns answer in powerd_angel
	mov cx, 0
	pop dx
	pop cx ; the power
	push dx ;adress
	mov ax, angel
	mov powerd_angel, ax
	mov dx, powerd_angel
	multiplayer:
		mult powerd_angel, dx 
		call power_10
		divider powerd_angel, bx
		mov powerd_angel, ax
	loop multiplayer
	ret
power_angel endp


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

angel_manager proc
	mov cx, 2
	call power_10
	mult cx, bx
	push cx
	mov dx, 0 
	mov ax, angel
	div cx
	mov angel, dx
	mov angel_cos, dx
	mov cx, 15 ;; 1.5, so we need to divide by 10 the pivot
	divider bx, 10 ;; here it breaks, the problem is val/val throws the div of.
	mov bx, ax
	mult cx, ax
	add dx, cx ;;
	mov ax, dx
	mov dx, 0
	pop cx
	div cx
	mov angel_cos, dx
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
fiting_pi_calc endp

larger_than_pi proc
	mov ax, angel
	mov cx,cx
	mov ax, ax
	call power_10;;
	cmp ax, bx
	jc larger_than_pi_false_angel
	mov Larger_Than_1_sin, 0
	jmp angel_cos_larger_than
	larger_than_pi_false_angel:
		mov Larger_Than_1_sin, 1
	angel_cos_larger_than:
		cmp ax, bx
		jc larger_than_pi_false_angel_cos
		mov Larger_Than_1_cos, 0
		jmp end_larger_pi
		larger_than_pi_false_angel_cos:
			mov Larger_Than_1_cos, 1
	end_larger_pi:
		ret
larger_than_pi endp

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
	start_ficPivot:
		mov ax, angel
		mov cx, 10
		mov bl, pivot
		cmp bl, 2
		jc end_fix_pivot
		jz end_fix_pivot
		add bl, 1
		mul cx
	end_fix_pivot:
		mov pivot, bl
		mov angel, ax
		ret
fixPivot endp