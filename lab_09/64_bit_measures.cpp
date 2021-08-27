#include "common.h"
#include "64_bit_measures.h"

double _64_bit_sum(double a, double b)
{
    return a + b;
}


double _64_bit_sum_asm(double a, double b)
{
    double c;

    __asm {
		finit;
        fld a;
        fld b;
        faddp ST(1), ST(0);
        fstp c;
    }

    return c;
}


double _64_bit_mul(double a, double b)
{
    return a * b;
}


double _64_bit_mul_asm(double a, double b)
{
    double c;

    __asm {
		finit;
        fld a;
        fld b;
        fmulp ST(1), ST(0);
        fstp c;
    }

    return c;
}



void print_64_bit_measures()
{
    double a = 1e23, b = 3e21;

    clock_t begin = clock();
    for (int i = 0; i < imax; ++i)
        _64_bit_sum(a, b);
    clock_t end = clock();

    printf("64 bit sum : %.3g\n", (double)(end - begin) / CLOCKS_PER_SEC / imax);


    begin = clock();
    for (int i = 0; i < imax; ++i)
        _64_bit_sum_asm(a, b);
    end = clock();

    printf("64 bit asm sum : %.3g\n", (double)(end - begin) / CLOCKS_PER_SEC / imax);


    begin = clock();
    for (int i = 0; i < imax; ++i)
        _64_bit_mul(a, b);
    end = clock();

    printf("64 bit mul : %.3g\n", (double)(end - begin) / CLOCKS_PER_SEC / imax);


    begin = clock();
    for (int i = 0; i < imax; ++i)
        _64_bit_mul_asm(a, b);
    end = clock();

    printf("64 bit asm mul : %.3g\n", (double)(end - begin) / CLOCKS_PER_SEC / imax);

    printf("\n");

}