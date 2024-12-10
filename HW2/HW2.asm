.data
    #Static arrays used to store the two string inputs
    str1: .space 200 # reserve a 200-byte memory block
    str2: .space 200 # reserve a 200-byte memory block
    #String literals
    printstr1: .asciiz "Enter the first string: "
    printstr2: .asciiz "Enter the second substring: "
    printstr3: .asciiz "Enter the insertion position: "
    printstr4: .asciiz "After insertion, updated first string is: "
    
.text
.globl main
main:
    li, $v0, 4 #to print prompt#1
    la $a0, printstr1
    syscall
    li, $v0, 8 #input the first string
    la $a0, str1
    li $a1, 200
    syscall
    li, $v0, 4 #print prompt #2
    la $a0, printstr2
    syscall
    li, $v0, 8 #input the second string
    la $a0, str2
    li $a1, 200
    syscall
    li, $v0, 4 #to print prompt#3
    la $a0, printstr3
    syscall
    li, $v0, 5 #input the position value(integer)
    syscall #pos stored in $v0

    la $a0, str1 #load the address of str1 to $a0
    la $a1, str2 #load the address of substr1 to $a1
    add $a2, $0, $v0 # load the position value to $a2s
    jal string_insert #procedure call from main
    
    li, $v0, 4 #print string mode
    la $a0, printstr4 #Literal part of Output
    syscall
    la $a0, str1 # load address of str1 for output
    syscall
    li, $v0, 10 #clean exit
    syscall


string_insert:
#definition of string_insert goes below
    # Function to insert a substring into a string at a specified position
    # Arguments:
    #   $a0 - address of the str1
    #   $a1 - address of the str2
    #   $a2 - position to insert the substring
    # Returns:
    #   $v0 - updated str1 with substr1 inserted at the specified position

    # Save the return address and arguments
    addi $sp, $sp, -12
    sw $ra, 0($sp)
    sw $a0, 4($sp)
    sw $a1, 8($sp)

    # Calculate the length of str1
    move $a0, $a0
    jal strlen
    move $s0, $v0  # Length of str1 stored in $s0
    # Calculate the length of str2
    lw $a0, 8($sp)
    jal strlen
    move $s1, $v0  # Length of str2 stored in $s1

    # Restore the return address and arguments
    lw $ra, 0($sp)
    lw $a0, 4($sp)
    lw $a1, 8($sp)
    addi $sp, $sp, 12

    # Calculate the new length of str1 after insertion
    add $s2, $s0, $s1

    # Shift the contents of str1 to the right to make space for str2
    add $t0, $a0, $s0  # Point to the end of str1
    add $t1, $a0, $s2  # Point to the new end of str1
    addi $t1, $t1, -1  # 1 less
    sub $t2, $s0, $a2  # Number of bytes to shift
    shift_loop:
    beq $t2, $zero, insert_substr  # If no more bytes to shift, go to insert_substr
    lb $t3, -1($t0)  # Load byte from str1
    sb $t3, -1($t1)  # Store byte to new position
    addi $t0, $t0, -1
    addi $t1, $t1, -1
    addi $t2, $t2, -1
    j shift_loop

    insert_substr:

    # 
    li, $v0, 4 #print string mode
    la $a0, str1 # load address of str1 for output
    syscall
    #


    # Insert str2 into str1 at the specified position
    add $t0, $a1, $zero  # Load address of str2
    add $t1, $a0, $a2  # Point to the insertion position in str1
    add $t3, $s1, $zero  # Copy the length of str2 to $t3
    addi $t3, $t3, -1  # 1 less
    insert_loop:
    lb $t2, 0($t0)  # Load byte from str2
    beq $t3, $zero, finish_insert  # If end of str2, finish
    sb $t2, 0($t1)  # Store byte to str1
    addi $t0, $t0, 1
    addi $t1, $t1, 1
    addi $t3, $t3, -1
    j insert_loop

    finish_insert:
    jr $ra


#Any additional function definition(s), including strlren
strlen:
    # Function to calculate the length of a string
    # Arguments:
    #   $a0 - address of the string
    # Returns:
    #   $v0 - length of the string

    # calee saves caller register values
    addi $sp, $sp, -32
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    sw $s3, 12($sp)
    sw $s4, 16($sp)
    sw $s5, 20($sp)
    sw $s6, 24($sp)
    sw $s7, 28($sp)

    move $t0, $a0  # Copy the address of the string to $t0
    
    li $t1, 0      # Initialize the length counter to 0
    strlen_loop:
    lb $t2, 0($t0) # Load the byte at the current address
    beq $t2, $zero, strlen_done # If the byte is null (end of string), exit loop
    addi $t1, $t1, 1 # Increment the length counter
    addi $t0, $t0, 1 # Move to the next byte
    j strlen_loop   # Repeat the loop
    strlen_done:
    
    move $v0, $t1   # Move the length counter to $v0

    # calee restores caller register values
    lw $s7, 28($sp)
    lw $s6, 24($sp)
    lw $s5, 20($sp)
    lw $s4, 16($sp)
    lw $s3, 12($sp)
    lw $s2, 8($sp)
    lw $s1, 4($sp) 
    lw $s0, 0($sp) 
    addi $sp, $sp, 32
    jr $ra          # Return from the function
