    .section .data
vector_a: 
    .word 1, 2, 3, 4, 5, 6, 7, 8  # Vector A (8 elements)
vector_b: 
    .word 8, 7, 6, 5, 4, 3, 2, 1  # Vector B (8 elements)

    .section .text
    .global _start
_start:
    # Load base addresses of the vectors
    li t0, 0x80000000          # Base address of vector A
    li t1, 0x80000020          # Base address of vector B

    # Set vector configuration
    li t2, 8                   # Number of elements in vector
    vsetvli t3, t2, e32        # Set VLEN to 32-bit elements, LMUL=1

    # Load vectors into v0 and v1
    vle32.v v0, (t0)           # Load vector A into v0
    vle32.v v1, (t1)           # Load vector B into v1

    # Perform element-wise multiplication
    vmul.vv v2, v0, v1         # Multiply v0 and v1, store result in v2

    # Reduce sum the result into scalar register x10
    vredsum.vs v3, v2, v0      # Reduce sum of v2 into v3
    vmv.x.s x10, v3                 # Move the result to scalar register x10

    # Exit program (if simulator supports ECALL for exit)
    li a7, 10                  # ECALL to exit
    ecall
