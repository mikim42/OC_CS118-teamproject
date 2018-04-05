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



movl $1, %eax
movl $0, %ebx
int $0x80
