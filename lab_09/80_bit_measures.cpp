#include "common.h"
#include "80_bit_measures.h"

long double _80_bit_sum(long double a, long double b)
{
    return a + b;
}


long double _80_bit_sum_asm(long double a, long double b)
{
    long double c;

    __asm {
		finit;
        fld a;
        fld b;
        faddp ST(1), ST(0);
        fstp c;
    }

    return c;
}


long double _80_bit_mul(long double a, long double b)
{
    return a * b;
}


long double _80_bit_mul_asm(long double a, long double b)
{
    long double c;

    __asm {
		finit;
        fld a;
        fld b;
        fmulp ST(1), ST(0);
        fstp c;
    }

    return c;
}



void print_80_bit_measures()
{
    long double a = 1e23, b = 3e21;

    clock_t begin = clock();
    for (int i = 0; i < imax; ++i)
        _80_bit_sum(a, b);
    clock_t end = clock();

    printf("80 bit sum : %.3g\n", (double)(end - begin) / CLOCKS_PER_SEC / imax);


    begin = clock();
    for (int i = 0; i < imax; ++i)
        _80_bit_sum_asm(a, b);
    end = clock();

    printf("80 bit asm sum: %.3g\n", (double)(end - begin) / CLOCKS_PER_SEC / imax);


    begin = clock();
    for (int i = 0; i < imax; ++i)
        _80_bit_mul(a, b);
    end = clock();

    printf("80 bit mul : %.3g\n", (double)(end - begin) / CLOCKS_PER_SEC / imax);


    begin = clock();
    for (int i = 0; i < imax; ++i)
        _80_bit_mul_asm(a, b);
    end = clock();

    printf("80 bit asm mul : %.3g\n", (double)(end - begin) / CLOCKS_PER_SEC / imax);


    printf("\n");

}