/*
Author: Victor Sanchez Gutierrez

This file will load a string into three different arrays (Disks)

*/

.data
str1: .asciz "This is a test string"
.equ str1Len, (. - str1)

.bss
.lcomm disk1 15
.lcomm disk2 15
.lcomm disk3 15
.lcomm parity 15

.text
.globl _start
_start:

push $parity
calll _setParity
addl $4, %esp


_setParity:
    pushl %ebp                           #This is the function prologue
    movl %esp, %ebp                      #and the next line of it
    movl 8(%ebp), %edi                   #The address of the parity
    movl $15, %ecx
    leal disk1, %eax
    leal disk2, %edx
    leal disk3, %esi
parityLoop:
    decl %ecx
    movb (%eax, %ecx, 1), %ebx
    xor (%edx, %ecx, 1), %ebx
    xor (%esi, %ecx, 1), %ebx
    movb %ebx, (%edi, %ecx, 1)
    incl %ecx
    loop parityLoop

return:                                 #Jump here if not found
    pop %ebp                             #Reset the stack
    retl                                 #Return to start function






movl $1, %eax
movl $0, %ebx
int $0x80
