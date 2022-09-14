.data
	CodeWord:		.byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	PotitionsForDigit1: 	.byte 1, 3, 5, 7, 9, 11, -1
	PotitionsForDigit2: 	.byte 2, 3, 6, 7, 10, 11, -1
	PotitionsForDigit4: 	.byte 4, 5, 6, 7, 12, -1
	PotitionsForDigit8: 	.byte 8, 9, 10, 11, 12, -1
	not_ok_message:		.asciiz "\n - Error in CodeWord"
	ok_message:		.asciiz "\n - No error in CodeWord"


.text
     
     la $t0, CodeWord #base register 
   
     li $s0, 0 # variable counter
     
     addi $s1,$zero,1
     
	while: 

	    	li $v0, 12 #input char
     		syscall 
     	
     	
     		bne $v0, 48, store_in #convert to digit
     	
     		addi $s0, $s0, 1 #addition to counter var 1 because we want the while to continue
    	
    		addi $t0, $t0, 1 #go to the next value of array
     	
     		j is_12_digits
       
		store_in: 
       
        		sb $s1, ($t0)
        	
        		addi $t0, $t0, 1 
        	
        		addi $s0, $s0, 1
	       		            		     
		is_12_digits:      

			blt $s0, 12, while # check if counter is 12
        
          			
	li $s0, 1 # variable counter
     			
	addi $t0, $t0, -12
     				
	while2:
		li $s1, 0 # variable sum
     	
     		la $t1, PotitionsForDigit1 #base register of array PotitionsForDigit1			
		beq $s0, 1, p

     		la $t1, PotitionsForDigit2 #base register of array PotitionsForDigit2		     				
		beq $s0, 2, p
     	
     		la $t1, PotitionsForDigit4 #base register of array PotitionsForDigit4
		beq $s0, 3, p
     				     				
		la $t1, PotitionsForDigit8 #base register of array PotitionsForDigit8
		beq $s0, 4, p
	


		p:
			lb $t2, ($t1) #load in register the data of array
     			
			beq $t2, -1, exit_loop #check if the variable is -1
     				
			sub $t2, $t2, 1 #subtraction from var 1 because a array stars from 0 and not from 1
     				
			add $t0, $t0, $t2 
     				
			lb $s2, ($t0) 

     			jal sum
     				     			
     			j p
     				 
     	sum: 
     				
     			add $s1, $s1, $s2 

     			addi $t1, $t1, 1 
     				
     			sub $t0, $t0, $t2
     				
     			jr $ra
     		 
     	exit_loop: 
     		
			addi $s0, $s0, 1
     			li $s3,2
			div $s1,$s3
			mfhi $t3
     					
			bne $t3, 0, not_ok
     				
			beq $s0, 4, ok
     				 
     			j while2
     	
	not_ok:
	
		li $v0, 4 
		la $a0, not_ok_message
		syscall
		j exit     			
     					
			
	ok:

		li $v0, 4
		la $a0, ok_message
		syscall
	
		j exit
     			

	exit:
     			
 		li $v0 10 
     		syscall
