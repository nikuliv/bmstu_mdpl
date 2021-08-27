.686
.model flat, C
.stack

.data 
	cnt dd 0
	src dd 0
	dst dd 0

.code
strl proc
	xor ecx, ecx
	xor eax, eax
	cld
	dec ecx
	repne scasb
	neg ecx
	ret
strl endp

my_strcpy proc
	push ebp
	mov ebp, esp

	mov edx, [ebp + 8]
	mov ecx, [ebp + 12]
	mov ebx, [ebp + 16]
	mov cnt, ebx
	mov src, ecx
	mov dst, edx

	cld
	mov edi, src
	call strl
	to_cmp:

	cmp ecx, cnt
	jna cont

	xchg ecx, cnt

	cont:
	mov edi, dst
	mov esi, src

	rep movsb

	push eax
	xor eax, eax
	mov [edi], eax
	pop eax

	mov esp, ebp
	pop ebp
	ret
my_strcpy endp
end