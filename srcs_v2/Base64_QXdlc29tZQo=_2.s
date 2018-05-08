# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Base64_QXdlc29tZQo=_2.s                            :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: mikim <mikim@student.42.us.org>            +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2018/05/01 10:36:25 by mikim             #+#    #+#              #
#    Updated: 2018/05/08 08:31:50 by mikim            ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# **************************************************************************** #
#                                                               Mingyun Kim    #
#                                            https://www.github.com/mikim42    #
# **************************************************************************** #

#                                   Jesse Brown : Mingyun Kim : Victor Sanchez #

.extern	_printString                # These are external C++ functions
.extern	_printStringN
.extern	_getString

.data
script00:	.string "Please enter data [max: 45 characters]:     | here!"   # Script for user input
.equ		len00, (. - script00)
script01:	.string "Which disk do you want to corrupt [1, 2, 3]?"          # Script for user corruption    
.equ		len01, (. - script01)
script02:	.string "\nAfter recovery:"                                     # Script after the corruption is made
.equ		len02, (. - script02)
script03:	.string "Disk 1: "          # Disk labels
script04:	.string "Disk 2: "
script05:	.string "Disk 3: "
script06:	.string "Parity: "          # Parity label
script07:	.string "Result: "          # Final rebuilt string label

.bss
.lcomm	input 4
.lcomm disk1 15                         # We set the size of the disks 
.lcomm disk2 15                         # to be 15 bytes each, so the length
.lcomm disk3 15                         # of the string can be max 45 bytes.
.lcomm parity 15                        # The parity disk size
.lcomm result 45                        # This is the string after it's rebuilt

.text
.globl _asmMain
_asmMain:
	push	%ebp                        # Create ASM main
	movl	%esp, %ebp

	push	$script00                   # Push address of string
	call	_printString                # Print string to console    
	addl	$4, %esp                    # Clean stack

	call	_getString                  # Get user input
	movl	%eax, input                 # Store into input variable

	pushl	$45                         # 45 is the max string
	pushl	input                       # Push the input string
	call	_loadDisks                  # Load the disks    
	addl	$8, %esp                    # Clean stack
	
	push	$disk3                      # Push the address of the disks
	push	$disk2                      # That have the stiped string into
	push	$disk1                      # the system stack
	push	$parity                     # along with the parity disk
	call	_RAID                       # Call the _RAID to build the Parity
	addl	$16, %esp                   # Clean the stack

	push	$script01
	call	_printString                # Ask user which disk to corrupt
	addl	$4, %esp                    # Clean stack

	call	_getString                  # Get user input
	cmpb	$'2', (%eax)                # Compare to see which disk they chose
	jb		_corruptDisk1               # If less than 2, they chose 1
	je		_corruptDisk2               # If equal they chose two
	ja		_corruptDisk3               # If above they chose three

_corruptDisk1:
	push	$disk1                      # Push the address of the disk
	call	_corruption                 # Call the corruption function
	addl	$4, %esp                    # Clean the stack

	push	$script03                   # This block will display
	call	_printStringN               # The state of the disks
	addl	$4, %esp                    # after the corruption has
	push	$disk1                      # been executed.
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

	push	$disk3                      # After the state of the disks has
	push	$disk2                      # been displayed, we need to rebuild
	push	$parity                     # the corrupted disk, so we call the 
	push	$disk1                      # RAID function with the corrupted disk
	call	_RAID                       # Pushed last
	addl	$16, %esp                   # Clear stack
	jmp		_end                        # Jump to end of program

_corruptDisk2:
	push	$disk2                      # Push the address of the disk
	call	_corruption                 # Call the corruption function
	addl	$4, %esp                    # Clean the stack

	push	$script03                   # This block will display
	call	_printStringN               # The state of the disks
	addl	$4, %esp                    # after the corruption has
	push	$disk1                      # been executed.
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

	push	$disk3                      # After the state of the disks has
	push	$disk1                      # been displayed, we need to rebuild
	push	$parity                     # the corrupted disk, so we call the 
	push	$disk2                      # RAID function with the corrupted disk
	call	_RAID                       # Pushed last
	addl	$16, %esp                   # Clear stack
	jmp		_end                        # Jump to end of program

_corruptDisk3:
	push	$disk3                      # Push the address of the disk
	call	_corruption                 # Call the corruption function
	addl	$4, %esp                    # Clean the stack

	push	$script03                   # This block will display
	call	_printStringN               # The state of the disks
	addl	$4, %esp                    # after the corruption has
	push	$disk1                      # been executed.
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

	push	$disk2                      # After the state of the disks has
	push	$disk1                      # been displayed, we need to rebuild
	push	$parity                     # the corrupted disk, so we call the 
	push	$disk3                      # RAID function with the corrupted disk
	call	_RAID                       # Pushed last
	addl	$16, %esp                   # Clear stack
	jmp		_end                        # Jump to end of program

_end:
	push	$script02                   # This will print the "After recovery"
	call	_printString
	addl	$4, %esp

	push	$script03                   # Disk 1 label
	call	_printStringN               # Print without newline
	addl	$4, %esp
	push	$disk1                      # Print disk1 contents
	call	_printString
	addl	$4, %esp

	push	$script04                   # Disk 2 label
	call	_printStringN               # Print without newline
	addl	$4, %esp
	push	$disk2                      # Print disk 2 contents
	call	_printString
	addl	$4, %esp

	push	$script05                   # Disk 3 label
	call	_printStringN               # Print without newline
	addl	$4, %esp
	push	$disk3
	call	_printString                # Print disk 3 contents
	addl	$4, %esp

	push	$script06                   # Parity label
	call	_printStringN               # Print without newline
	addl	$4, %esp
	push	$parity                     # Print parity contents
	call	_printString
	addl	$4, %esp

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

	push	$script07
	call	_printStringN
	addl	$4, %esp
	push	$result                     # Print result string, which should be identical
	call	_printString                # To the input string
	addl	$4, %esp

	pop		%ebp                        # Pop ASM Main
	retl                                # Return to C++ Main

# Function loadDisks
_loadDisks:
	pushl	%ebp                        # Build the stack frame
	movl	%esp, %ebp                  # Move the stack pointer
	movl	12(%ebp), %ecx              # Grab the length of string and store
	movl	8(%ebp), %edi				# Move the input string to EDI
	movl	$0, %ebx                    # Load 0 into ebx and esi
	movl	$0, %esi
	_diskLoadLoop:
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
