divider32 macro num1, num2 ; result returns in ax ; doesn't cahnge num1
	push bx
	;;push dx 
	mov ax, num1
	mov bx, num2
	div bx
	;;pop dx
	pop bx
endm 

mult32 macro num1, num2 ; can't be ax or dx; dx large part, num1 small part
	push ax
	push cx
	mov ax, num1
	mov cx, num2
	mul cx
	pop cx
	mov num1, ax
	pop ax
endm

power_angel32 proc ;; multiplayes the angel ;; recieves the power in the stack ;; returns answer in powerd_angel
	mov cx, 0
	pop dx
	pop cx ; the power
	dec cx
	push dx ;adress
	mov ax, angel
	mov powerd_angel, ax
	mov bx, powerd_angel
	multiplayer32:
		mov dx, 0
		mult32 powerd_angel, bx
		push bx
		call power_10 ; doesn't effect dx
		divider32 powerd_angel, bx
		mov powerd_angel, ax
		pop bx
	loop multiplayer32
	ret
power_angel32 endp

power_angel proc ;; multiplayes the angel ;; recieves the power in the stack ;; returns answer in powerd_angel
	mov cx, 0
	pop dx
	pop cx ; the power
	push dx ;adress
	dec cx
	mov ax, angel
	mov powerd_angel, ax
	mov bx, powerd_angel
	mov dx, 0 
	multiplayer:
		mult32 powerd_angel, bx
		push bx ;; saves the powerd angel;
		call power_10
		divider32 powerd_angel, bx
		pop bx ;; returns the powerd_angel to bx
		mov powerd_angel, ax
		cmp dl, half_pivot
		jc loop_PA_mul
		inc powerd_angel ;; fixes round errors.
loop_PA_mul:
	mov dx, 0
	loop multiplayer
	ret
power_angel endp