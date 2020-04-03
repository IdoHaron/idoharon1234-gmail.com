enter_char proc ;; the ouput from console is saved in al; destroys ax.
	mov ah, 01h
	int 21h
	ret
enter_char endp

enter_notFullPos proc
	mov bx, 0
	mov cl, 0
	mov ch, 0 
	num_enter:
		call enter_char
		cmp al, "."
		jnz after_point
		mov cl, 1
		sub al, "0"
		jmp num_enter
		after_point: 
			sub al, "0"
			jc end_input
			cmp al, 10
			jnc end_input
			adding_number:
				mult bx, 10
				mov ah, 0
				add bx, ax
				cmp cl, 0
				jz check_enteredZero
				inc cl
				check_enteredZero:
					cmp bx, 0
					jz after_add
					inc ch
					after_add:
						jmp num_enter
	end_input:
		mov angel, bx
		dec cl
		mov pivot, cl
		cmp ch, cl
		jc pivot_largerThanNumCount
		sub ch, cl
		ret
	pivot_largerThanNumCount:
		mov length_larger_than1, 0 
		ret
enter_notFullPos endp