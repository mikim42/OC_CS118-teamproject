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
 
leal str1, %edi
movl $str1Len, %ecx

pushl %ecx
pushl %edi
calll _loadDisks
addl $8, %esp


movl $1, %eax
movl $0, %ebx
int $0x80


_loadDisks:
pushl %ebp
movl %esp, %ebp
movl 12(%ebp), %ecx
movl $0, %ebx
movl $0, %esi
diskLoadLoop:
movl 8(%ebp), %edi
movb (%edi, %ebx, 1), %al
leal disk1, %edx
movb %al, (%edx, %esi, 1)

incl %ebx
cmpl %ebx, 12(%ebp)
je returnLoadDisks

movb (%edi, %ebx, 1), %al
leal disk2, %edx
movb %al,  (%edx, %esi, 1)

incl %ebx
cmpl %ebx, 12(%ebp)
je returnLoadDisks

movb (%edi, %ebx, 1), %al
leal disk3, %edx
movb %al, (%edx, %esi, 1)

incl %ebx
cmpl %ebx, 12(%ebp)
je returnLoadDisks

incl %esi

loop diskLoadLoop

returnLoadDisks:
popl %ebp
retl
