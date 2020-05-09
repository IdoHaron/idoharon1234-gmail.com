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
	pop bx ;; input
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

print_result proc ;; works;
zero_check_print:
	cmp result, 0
	jnz start_print_res
	print_char "0"
	jmp end_printResult
start_print_res:
	cmp isNeg_result, 1
	jnz is_inf
	print_char "-"
is_inf:	cmp result, 65535
	jc number_printing
	print inf 
	jmp end_printResult
number_printing:	call power_10
	divider result, bx
	cmp ax, 1
	jz print_fullPart
	jc not_full_num_0
print_fullPart:	push ax ;; saves the value,. for print_num not to change.
	push ax ;; fixing the function for sin. we will divede by the power of 10, and then we will multiplye
	call print_num
	pop ax
	call power_10
	mov cx, ax
	mult cx, bx ; get the full part of the resutlt and then sub it for the result.
	sub result, cx
	jz end_printResult
	not_full_num:
		print_char "." ;; starts change
		call power_10
	zero_print:	divider bx, 10
		mov cx, ax
		mov bx, ax
		divider result, cx
		cmp ax, 0
		jnz not_full_num_fin
		print_char "0"
		jmp zero_print
		not_full_num_fin: ;; end change
		push result
		call print_num
		ret
	not_full_num_0:
		print_char "0"
		jmp not_full_num 
end_printResult:
	ret
print_result endp