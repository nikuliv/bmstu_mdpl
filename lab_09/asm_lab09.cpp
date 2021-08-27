#include <stdio.h>
#include <math.h>

#include "common.h"

#include "32_bit_measures.h"
#include "64_bit_measures.h"
#include "80_bit_measures.h"

void sin_cmp() {
    double res = 0.0;

    printf("sin(pi)\n");
    printf("3.14 : %g\n", sin(3.14));
    printf("3.141596 : %g\n", sin(3.141596));

    __asm {
        fldpi;
        fsin;
        fstp res;
    }
    printf("asm : %g\n", res);


    printf("\n");

    printf("sin(pi / 2)\n");
    printf("3.14 / 2 : %g\n", sin(3.14 / 2));
    printf("3.141596 / 2: %g\n", sin(3.141596 / 2));


    res = 2.0;
    __asm {
        fldpi;
        fld1;
        fld1;
        faddp  ST(1), ST(0);
        fdiv;
        fsin;
        fstp res;
    }
    printf("asm : %g\n", res);


    printf("\n");
}

int main() {
    sin_cmp();

    print_32_bit_measures();

    print_64_bit_measures();

    print_80_bit_measures();

    return 0;
}
