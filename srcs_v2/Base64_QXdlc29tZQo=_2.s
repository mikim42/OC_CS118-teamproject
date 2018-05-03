# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Base64_QXdlc29tZQo=_2.s                            :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: mikim <mikim@student.42.us.org>            +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2018/05/01 10:36:25 by mikim             #+#    #+#              #
#    Updated: 2018/05/03 08:48:32 by mikim            ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# **************************************************************************** #
#                                                               Mingyun Kim    #
#                                            https://www.github.com/mikim42    #
# **************************************************************************** #

#                                   Jesse Brown : Mingyun Kim : Victor Sanchez #

.extern	_printString
.extern	_printStringN
.extern	_getString

.data
script00:	.string "Please enter data [max: 45 characters]:     | here!"
.equ		len00, (. - script00)
script01:	.string "Which disk do you want to corrupt [1, 2, 3]?"
.equ		len01, (. - script01)
script02:	.string "\nAfter recover:"
.equ		len02, (. - script02)
script03:	.string "Disk 1: "
script04:	.string "Disk 2: "
script05:	.string "Disk 3: "
script06:	.string "Parity: "
script07:	.string "Result: "

.bss
.lcomm	input 4
.lcomm	disk1 15
.lcomm	disk2 15
.lcomm	disk3 15
.lcomm	parity 15
.lcomm	result 45

.text
.globl _asmMain
_asmMain:
	push	%ebp
	movl	%esp, %ebp

	push	$script00
	call	_printString
	addl	$4, %esp

	call	_getString
	movl	%eax, input

	pushl	$45
	pushl	input
	call	_loadDisks
	addl	$8, %esp
	
	push	$disk3
	push	$disk2
	push	$disk1
	push	$parity
	call	_RAID
	addl	$16, %esp

	push	$script01
	call	_printString
	addl	$4, %esp

	call	_getString
	cmpb	$'2', (%eax)
	jb		_corruptDisk1
	je		_corruptDisk2
	ja		_corruptDisk3

_corruptDisk1:
	push	$disk1
	call	_corruption
	addl	$4, %esp

	push	$script03
	call	_printStringN
	addl	$4, %esp
	push	$disk1
	call	_printString
	addl	$4, %esp
	push	$disk2
	call	_printString
	addl	$4, %esp
	push	$disk3
	call	_printString
	addl	$4, %esp
	push	$parity
	call	_printString
	addl	$4, %esp

	push	$disk3
	push	$disk2
	push	$parity
	push	$disk1
	call	_RAID  #tHIS IS A TEMPORARY RECOVER OPTION, IT'S JUST A COPY OF LOAD PARITY
	addl	$16, %esp
	jmp		_end

_corruptDisk2:
	push	$disk2
	call	_corruption
	addl	$4, %esp

	push	$script03
	call	_printStringN
	addl	$4, %esp
	push	$disk1
	call	_printString
	addl	$4, %esp

	push	$script04
	call	_printStringN
	addl	$4, %esp
	push	$disk2
	call	_printString
	addl	$4, %esp

	push	$script05
	call	_printStringN
	addl	$4, %esp
	push	$disk3
	call	_printString
	addl	$4, %esp

	push	$script06
	call	_printStringN
	addl	$4, %esp
	push	$parity
	call	_printString
	addl	$4, %esp

	push	$disk3
	push	$disk1
	push	$parity
	push	$disk2
	call	_RAID  #tHIS IS A TEMPORARY RECOVER OPTION, IT'S JUST A COPY OF LOAD PARITY
	addl	$16, %esp
	jmp		_end

_corruptDisk3:
	push	$disk3
	call	_corruption
	addl	$4, %esp

	push	$script03
	call	_printStringN
	addl	$4, %esp
	push	$disk1
	call	_printString
	addl	$4, %esp

	push	$script04
	call	_printStringN
	addl	$4, %esp
	push	$disk2
	call	_printString
	addl	$4, %esp

	push	$script05
	call	_printStringN
	addl	$4, %esp
	push	$disk3
	call	_printString
	addl	$4, %esp

	push	$script06
	call	_printStringN
	addl	$4, %esp
	push	$parity
	call	_printString
	addl	$4, %esp

	push	$disk2
	push	$disk1
	push	$parity
	push	$disk3
	call	_RAID  #tHIS IS A TEMPORARY RECOVER OPTION, IT'S JUST A COPY OF LOAD PARITY
	addl	$16, %esp
	jmp		_end

_end:
	push	$script02
	call	_printString
	addl	$4, %esp

	push	$script03
	call	_printStringN
	addl	$4, %esp
	push	$disk1
	call	_printString
	addl	$4, %esp

	push	$script04
	call	_printStringN
	addl	$4, %esp
	push	$disk2
	call	_printString
	addl	$4, %esp

	push	$script05
	call	_printStringN
	addl	$4, %esp
	push	$disk3
	call	_printString
	addl	$4, %esp

	push	$script06
	call	_printStringN
	addl	$4, %esp
	push	$parity
	call	_printString
	addl	$4, %esp

	movl	$15, %ecx
	xor		%eax, %eax
	xor		%ebx, %ebx
	xor		%edx, %edx
	movl	$result, %esi

	_getResult:
		movl	$disk1, %edi
		movb	(%edi, %eax, 1), %dl
		movb	%dl, (%esi, %ebx, 1)
		inc		%ebx
		movl	$disk2, %edi
		movb	(%edi, %eax, 1), %dl
		movb	%dl, (%esi, %ebx, 1)
		inc		%ebx
		movl	$disk3, %edi
		movb	(%edi, %eax, 1), %dl
		movb	%dl, (%esi, %ebx, 1)
		inc		%ebx
		inc		%eax
		loop	_getResult

	push	$script07
	call	_printStringN
	addl	$4, %esp
	push	$result
	call	_printString
	addl	$4, %esp

	pop		%ebp
	retl

# Function loadDisks
_loadDisks:
	pushl	%ebp
	movl	%esp, %ebp
	movl	12(%ebp), %ecx
	movl	$0, %ebx
	movl	$0, %esi
	_diskLoadLoop:
		movl	8(%ebp), %edi
		movb	(%edi, %ebx, 1), %al
		leal	disk1, %edx
		movb	%al, (%edx, %esi, 1)

	incl	%ebx
	cmpl	%ebx, 12(%ebp)
	je		_returnLoadDisks

	movb	(%edi, %ebx, 1), %al
	leal	disk2, %edx
	movb	%al,  (%edx, %esi, 1)

	incl	%ebx
	cmpl	%ebx, 12(%ebp)
	je		_returnLoadDisks

	movb	(%edi, %ebx, 1), %al
	leal	disk3, %edx
	movb	%al, (%edx, %esi, 1)

	incl	%ebx
	cmpl	%ebx, 12(%ebp)
	je		_returnLoadDisks

	incl	%esi

	loop	_diskLoadLoop

_returnLoadDisks:
	pop		%ebp
	ret

# Function RAID
_RAID:
_RAID:
	pushl	%ebp							#This is the function prologue
	movl	%esp, %ebp						#and the next line of it.
	movl	8(%ebp), %edi					#The address of the parity/corrupted disk.
	movl	12(%ebp), %eax                  #The address of the other 3 disks which
	movl	16(%ebp), %edx                  #are a combination of disk1, 2, 3, or the
	movl	20(%ebp), %esi                  #parity. 
	movl	$15, %ecx                       #Move 15 into ECX as a loop counter.
	_RAIDLoop:
		decl	%ecx                        #Decrement ECX to use it as an index.
		movb	(%eax, %ecx, 1), %bl        #Move an element into BL then XOR
		xor		(%edx, %ecx, 1), %ebx       #it with an element of the other disks.
		xor		(%esi, %ecx, 1), %ebx       #
		movb	%bl, (%edi, %ecx, 1)        #Move the result into parity/recovered
		incl	%ecx                        #disk. Increase ECX for loop count.
		loop	_RAIDLoop                   #Check if done.

	pop		%ebp						    #Reset the stack
	retl								    #Return to start function


# Function corruption
_corruption:
	pushl	%ebp
	movl	%esp, %ebp

	mov		8(%ebp), %esi
	mov		$15, %ecx
	xor		%eax, %eax

	_corruptLoop:
		xor		$'A', (%esi, %eax, 1)
		inc		%eax
		loop	_corruptLoop

	popl	%ebp
	retl
