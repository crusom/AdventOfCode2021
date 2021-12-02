.data
buffer:
   .skip 1
handle:
   .word 0x00000000
   .word 0x00000000
digits:
   .asciz "0123456789\n"
.text
.global _start

_start:
   ldr r0, =file    @ filename
   mov r1, #2       @ flag
   ldr r2, =0666    @ mode
   mov r7, #5       @ 'open' syscall
   swi #0
   
   ldr r9, =0x7fffffff @ set prev num as the highest value, to exclude it from being marked as 'increased', when the first prev num and curr num comparison is done

   ldr r3, phandle
   str r0, [r3] 
   
   ldr r1, pbuffer 
   mov r2, #1       @ read every char
   mov r7, #3       @ read syscall

readloop:
   ldr r0, [r3]     @ handle
   swi #0
   cmp r0, #0
   beq end
   
   ldrb r0, [r1]    @ load only byte
   cmp r0, #'\n'
   beq getnumhelper

   sub r0, #0x30
   add r4, #1
   push {r0}
   b readloop


getnumhelper:
   pop {r0}
   mov r5, r0       @ r5 current number
   mov r6, #1       @ r6 multiplier
   mov r8, #1

getnum:
   pop {r0}

   push {r8, r10}
   mov r10, #10
   mul r8, r6, r10  @ multiplier x 10
   mov r6, r8
   mul r10, r6, r0  @ (multiplier x 10) x digit
   add r5, r10
   pop {r8, r10}

   add r8, #1
   cmp r8, r4       @ cmp multiplier and num of digits of the number
   bne getnum
   
   cmp r9, r5       @ r9 prev num
   addlt r10, #1
   mov r9, r5       @ prev num = curr num
   mov r4, #0
   b readloop

end:
   mov r5, #10      @ x 10
   mov r8, #0       @ counter
   mov r7, #4       @ syscall 'write'

reversenum:
   add r8, #1
   udiv r2, r10, r5
   mls r6, r2, r5, r10
   mov r10, r2

   push {r6}

   cmp r10, #0
   bne reversenum

   mov r10, r8       @ num / 10
   mov r2, #1        @ num of bytes to write
   mov r0, #1        @ STDOUT

printnum:
   sub r10, #1   
   pop {r6}
   
   ldr r1, pdigits
   add r1, r6
   swi #0

   cmp r10, #0
   bne printnum

                     @ print '\n' at the end
   ldr r1, pdigits
   add r1, #10
   swi #0
   
   mov r7, #6
   ldr r0, [r3]      @ politely close the file :)
   swi #0

   mov r7, #1        @ syscall 'exit'
   mov r0, #0        @ error code 0
   swi #0 

phandle: .word handle
pbuffer: .word buffer
pdigits: .word digits
file: .asciz "input"
.end
