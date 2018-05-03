# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Base64_QXdlc29tZQo=.s                              :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: mikim <mikim@student.42.us.org>            +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2018/05/01 10:36:25 by mikim             #+#    #+#              #
#    Updated: 2018/05/03 08:31:45 by mikim            ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# **************************************************************************** #
#                                                               Mingyun Kim    #
#                                            https://www.github.com/mikim42    #
# **************************************************************************** #

#                                   Jesse Brown : Mingyun Kim : Victor Sanchez #

.data
str1: .string "This is a test string"
.equ str1Len, (. - str1)

.bss
.lcomm disk1 15
.lcomm disk2 15
.lcomm disk3 15
.lcomm parity 15
.lcomm result 45

.text
.globl _start
_start:
 
	leal	str1, %edi
	movl	$str1Len, %ecx

	pushl	%ecx
	pushl	%edi
	call	_loadDisks
	addl	$8, %esp
	
	push	$disk3
	push	$disk2
	push	$disk1
	push	$parity
	call	_RAID
	addl	$16, %esp

	push	$disk1
	call	_corruption
	addl	$4, %esp

	push	$disk3
	push	$disk2
	push	$parity
	push	$disk1
	call	_RAID  #tHIS IS A TEMPORARY RECOVER OPTION, IT'S JUST A COPY OF LOAD PARITY
	addl	$16, %esp

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

_end:
	movl $1, %eax
	movl $0, %ebx
	int $0x80

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
	popl	%ebp
	retl

# Function RAID
_RAID:
	pushl	%ebp							#This is the function prologue
	movl	%esp, %ebp						#and the next line of it
	movl	8(%ebp), %edi					#The address of the parity
	movl	12(%ebp), %eax
	movl	16(%ebp), %edx
	movl	20(%ebp), %esi
	movl	$15, %ecx
	_RAIDLoop:
		decl	%ecx
		movb	(%eax, %ecx, 1), %bl
		xor		(%edx, %ecx, 1), %ebx
		xor		(%esi, %ecx, 1), %ebx
		movb	%bl, (%edi, %ecx, 1)
		incl	%ecx
		loop	_RAIDLoop

	pop		%ebp						#Reset the stack
	retl								#Return to start function

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
