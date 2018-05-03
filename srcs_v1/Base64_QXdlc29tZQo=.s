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
str1: .string "This is a test string"   # This is the string that will be striped
.equ str1Len, (. - str1)                # Size of string

.bss
.lcomm disk1 15                         # We set the size of the disks 
.lcomm disk2 15                         # to be 15 bytes each, so the length
.lcomm disk3 15                         # of the string can be max 45 bytes.
.lcomm parity 15                        # The parity disk size
.lcomm result 45                        # This is the string after it's rebuilt

.text
.globl _start
_start:
 
	leal	str1, %edi                  # Load string address                                
	movl	$str1Len, %ecx              # Load string length in ecx

	pushl	%ecx                        # Push into sys stack in reverse
	pushl	%edi                        # order, following Cdecl
	call	_loadDisks                  # Call function
	addl	$8, %esp                    # Clean up stack
	
	push	$disk3                      # Push the address of the disks
	push	$disk2                      # That have the stiped string into
	push	$disk1                      # the system stack
	push	$parity                     # along with the parity disk
	call	_RAID                       # Call the _RAID to build the Parity
	addl	$16, %esp                   # Clean the stack

	push	$disk1                      # Push address of disk 1 into stack
	call	_corruption                 # Call the corruption function
	addl	$4, %esp                    # Clean stack

	push	$disk3                      # This is similar to the way we
	push	$disk2                      # built the parity disk, except the 
	push	$parity                     # order in which the disks are pushed
	push	$disk1                      # is different. This is because the 
	call	_RAID                       # RAID function rebuilds the disk that
	addl	$16, %esp                   # is pushed last.

	movl	$15, %ecx                   # We move 15 into ecx because that's the 
	xor		%eax, %eax                  # size of the disks
	xor		%ebx, %ebx
	xor		%edx, %edx
	movl	$result, %esi               # Result is the address of the string
	_getResult:                         # This section essentially does the reverse
		movl	$disk1, %edi            # of the loadDisk function, it goes through
		movb	(%edi, %eax, 1), %dl    # the disks and grabs a letter from     
		movb	%dl, (%esi, %ebx, 1)    # an index and moves that letter into
		inc		%ebx                    # the appropriate index in the result string
		movl	$disk2, %edi
		movb	(%edi, %eax, 1), %dl
		movb	%dl, (%esi, %ebx, 1)
		inc		%ebx
		movl	$disk3, %edi
		movb	(%edi, %eax, 1), %dl
		movb	%dl, (%esi, %ebx, 1)
		inc		%ebx
		inc		%eax
		loop	_getResult              # Loop until we reach the end of the disks

_end:   # End of ASM program
	movl $1, %eax
	movl $0, %ebx
	int $0x80

# Function loadDisks
_loadDisks:
	pushl	%ebp                        # Build the stack frame
	movl	%esp, %ebp                  # Move the stack pointer
	movl	12(%ebp), %ecx              # Grab the length of string and store
	movl	$0, %ebx                    # Load 0 into ebx and esi
	movl	$0, %esi
	_diskLoadLoop:
		movl	8(%ebp), %edi           # Move the address of string into edi
		movb	(%edi, %ebx, 1), %al    # Grab a letter from the string into al
		leal	disk1, %edx             # Load the address of disk1
		movb	%al, (%edx, %esi, 1)    # Move that letter into the spot in disk1    

	incl	%ebx                        # Increment the index
	cmpl	%ebx, 12(%ebp)              # Check if the index is the length of the string
	je		_returnLoadDisks            # If so, we have reached the end of the string

	movb	(%edi, %ebx, 1), %al        # Otherwise grab another letter from the string
	leal	disk2, %edx                 # Load address of disk 2
	movb	%al,  (%edx, %esi, 1)       # Move that letter into the index in disk 2

	incl	%ebx
	cmpl	%ebx, 12(%ebp)              # Increment index and Perform check again
	je		_returnLoadDisks

	movb	(%edi, %ebx, 1), %al        # Grab a letter from the string
	leal	disk3, %edx                 # Load address of Disk3
	movb	%al, (%edx, %esi, 1)        # Move that letter into the index in disk 3

	incl	%ebx                                
	cmpl	%ebx, 12(%ebp)              # Increment index and perform check again
	je		_returnLoadDisks

	incl	%esi                        # Increment index of the disks

	loop	_diskLoadLoop               # Loop

_returnLoadDisks:
	popl	%ebp                        # End of function
	retl

# Function RAID
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
	pushl	%ebp                            # Create function stack
	movl	%esp, %ebp

	mov		8(%ebp), %esi                   # Get address of string
	mov		$15, %ecx                       # Move 15 because that's the size of string
	xor		%eax, %eax                      # Clear eax

	_corruptLoop:
		xor		$'A', (%esi, %eax, 1)       # Random change of value of character in index
		inc		%eax                        # Increase index
		loop	_corruptLoop                # loop

	popl	%ebp                            # End of function
	retl
