print macro msg ;;destroys dx, ax
	mov dx, offset msg
	mov ah, 9
	int 21h
endm

print_char macro char
	mov dl, char
	mov ah, 02h
	int 21h
endm
downLine proc
	print_char 0ah
	ret
downLine endp

print_num proc
	pop dx
	pop bx
	push dx
	mov ax, bx
	mov cl, 0
	mov dx, 0
	number_enterStack:
		cmp ax, 0
		jz print_num_stack
		inc cl
		mov bx , 10 
		div bx
		mov bx, ax
		push dx
		mov ax, bx
		mov dx, 0
		jmp number_enterStack
	print_num_stack:
		pop dx
		add dx, '0'
		mov ah, 02h
		int 21h
		dec cl
		jnz print_num_stack
		ret
print_num endp

print_result proc
	cmp result, 65535
	jc start_print_res
	print inf
	jmp end_printResult
start_print_res:	cmp isNeg_result, 1
	jnz number_printing
	print_char "-"
number_printing:	call power_10
	divider result, bx
	cmp bx, 1
	jc not_full_num_0
	push bx
	push bx ;; fixing the function for sin. we will divede by the power of 10, and then we will multiplye
	call print_num
	pop bx
	mov cx, bx
	call power_10
	mult cx, bx ; get the full part of the resutlt and then sub it for the result.
	sub result, cx
	jz end_printResult
	not_full_num:
		print_char "."
		push result
		call print_num
	not_full_num_0:
		print_char "0"
		jmp not_full_num
end_printResult:
	ret
print_result endp