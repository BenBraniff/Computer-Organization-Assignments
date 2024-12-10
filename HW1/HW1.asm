# This Code draws a Rectangle on the console
# 1. Height: the number of lines used to draw the rectangle
# 2. Width: the number of characters in each line.
# 3. Border: the character used to draw the rectangle’s periphery
# 4. Fill: the character used to draw the rectangle’s inner points
# For example, a rectangle of Height=5, Width=4, Border='*' and Fill ='@' would print as follows:
# ****
# *@@*
# *@@*
# *@@*
# ****

.data
H: .word 5 # stores the number 5 in the data label H
W: .word 4 # stores the number 4 in the data label W
B: .word '*' # stores the letter '*' in the data label B
F: .word '@' # stores the letter '@' in the data label F
newline: .byte '\n' # stores the newline symbol in the data label newline
I: .word 0 # stores the number 0 in the data label I
J: .word 0 # stores the number 0 in the data label J


.text
main:
    lw $s0, H # load H into register $s0
    lw $s1, W # load W into register $s1
    lw $s4, newline # load newline into register $s4
    lw $s5, I # load I into register $s5
    lw $s6, J # load J into register $s6
    li $s7, 1 # load 1 into register $s7

    li $t1, 0 # t1 = 0
    li $t2, 0 # t2 = 0
    li $t3, 0 # t3 = 0
    li $t4, 0 # t4 = 0

    li $s5, 0 # i = 0
    whileloop1:
        slt $t0, $s5, $s0 # if i < H then t0 = 1
        beq $t0, $zero, endloop1 # if t0 == 0 end loop1
        
        li $s6, 0 # j = 0
        whileloop2:
            slt $t0, $s6, $s1 # if j < W then t0 = 1
            beq $t0, $zero, endloop2 # if t0 == 0 then end loop2

            # precalulations

            bne $s5, $zero, else1 # if i==0 then case1=1 else case1=0
            li $t1, 1 # t1 = 1
            j end1
            else1:
            li $t1, 0 # t1 = 0
            end1:

            sub $t0, $s0, $s7 # t0 = H-1
            bne $s5, $t0, else2 # if i==H-1 then case2=1 else case2=0
            li $t2, 1 # t2 = 1
            j end2 
            else2:
            li $t2, 0 # t2 = 0
            end2:

            bne $s6, $zero, else3 # if j==0 then case3=1 else case3=0
            li $t3, 1 # t3 = 1
            j end3
            else3:
            li $t3, 0 # t3 = 0
            end3:

            sub $t0, $s1, $s7 # t0 = W-1
            bne $s6, $t0, else4 # if j==W-1 then case4=1 else case4=0
            li $t4, 1 # t4 = 1
            j end4
            else4:
            li $t4, 0 # t4 = 0
            end4:

            # actual code part

            or $t0, $t1, $t2 # t0 = (case1 or case2)
            beq $t0, $zero, endif1 # if (case1 or case2): then run code
            li $v0, 4 # syscall code for print_string
            la $a0, B # print B
            syscall
            j endelseif # if the if-block code runs, leave if-else block of code
            endif1:

            or $t0, $t3, $t4 # t0 = (case3 or case4)
            beq $t0, $zero, else # if (case3 or case4): then run code
            li $v0, 4 # syscall code for print_string
            la $a0, B # print B
            syscall
            j endelseif # if the if-block code runs, leave if-else block of code

            else:
            li $v0, 4 # syscall code for print_string
            la $a0, F # print F
            syscall
            endelseif:

            addi $s6, $s6, 1 # j = j + 1
            j whileloop2
        endloop2:
            
        li $v0, 4 # syscall code for print_string
        la $a0, newline # print newline
        syscall

        addi $s5, $s5, 1 # i = i + 1
        j whileloop1
    endloop1:
    li $v0, 10 # terminate program
    syscall