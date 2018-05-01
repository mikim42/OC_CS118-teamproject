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

push $parity
calll _setParity
addl $4, %esp
#THIS IS DISK CORRUPTION
xor %eax, %eax
xor %edi, %edi
movl $0, %eax
leal disk2, %edi
movl $15, %ecx
cld
rep stosb
#END OF DISK CORRUPTION
push $disk2
calll _recoverDisk  #tHIS IS A TEMPORARY RECOVER OPTION, IT'S JUST A COPY OF LOAD PARITY
addl $4, %esp



endOfProgram:
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






_recoverDisk:
    pushl %ebp                           #This is the function prologue
    movl %esp, %ebp                      #and the next line of it
    movl 8(%ebp), %edi                   #The address of the parity
    movl $15, %ecx
    leal disk1, %eax
    leal parity, %edx
    leal disk3, %esi
parityLoop2:
    decl %ecx
    movb (%eax, %ecx, 1), %ebx
    xor (%edx, %ecx, 1), %ebx
    xor (%esi, %ecx, 1), %ebx
    movb %ebx, (%edi, %ecx, 1)
    incl %ecx
    loop parityLoop2

return2:                                 #Jump here if not found
    pop %ebp                             #Reset the stack
    retl                                 #Return to start function

