#include "pch.h"
#include <iostream>

extern "C"
{
	void my_strcpy(char* dst, const char* src, int cnt);
}

int my_strlen(const char* str_cpy)
{
	int len;

	__asm
	{
		mov edi, str_cpy
		xor ecx, ecx
		xor eax, eax
		cld
		dec ecx
		repne scasb
		neg ecx
		mov len, ecx
	}

	return len;
}

int main()
{
	const char* to_cpy = "Hello world!";
	char buf[80];

	my_strcpy(buf, to_cpy, 10);

	std::cout << buf << std::endl;
}