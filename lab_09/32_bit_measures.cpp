#include "common.h"
#include "32_bit_measures.h"

float _32_bit_sum(float a, float b)
{
    return a + b;
}


float _32_bit_sum_asm(float a, float b)
{
    float c;

    __asm {
		finit;
        fld a;
        fld b;
        faddp ST(1), ST(0);
        fstp c;
    }

    return c;
}


float _32_bit_mul(float a, float b)
{
    return a * b;
}


float _32_bit_mul_asm(float a, float b)
{
    float c;

    __asm {
		finit;
        fld a;
        fld b;
        fmulp ST(1), ST(0);
        fstp c;
    }

    return c;
}



void print_32_bit_measures()
{
    float a = 1e23, b = 3e21;

    clock_t begin = clock();
    for (int i = 0; i < imax; ++i)
        _32_bit_sum(a, b);
    clock_t end = clock();

    printf("32 bit sum : %.3g\n", (double)(end - begin) / CLOCKS_PER_SEC / imax);


    begin = clock();
    for (int i = 0; i < imax; ++i)
        _32_bit_sum_asm(a, b);
    end = clock();

    printf("32 bit asm sum : %.3g\n", (double)(end - begin) / CLOCKS_PER_SEC / imax);


    begin = clock();
    for (int i = 0; i < imax; ++i)
        _32_bit_mul(a, b);
    end = clock();

    printf("32 bit mul : %.3g\n", (double)(end - begin) / CLOCKS_PER_SEC / imax);


    begin = clock();
    for (int i = 0; i < imax; ++i)
        _32_bit_mul_asm(a, b);
    end = clock();

    printf("32 bit asm mul : %.3g\n", (double)(end - begin) / CLOCKS_PER_SEC / imax);


    printf("\n");

}