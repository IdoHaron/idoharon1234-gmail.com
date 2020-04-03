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
	cmp isNeg_result, 1
	jnz number_printing
	print_char "-"
number_printing:	call power_10
	divider result, bx
	cmp bx, 1
	jnz not_full_num
	print_char "1"
	jmp end_printResult
	not_full_num:
		print not_full_numM
		push result
		call print_num
end_printResult:
	ret
print_result endp