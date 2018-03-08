main: add $t0, $s0, $zero
      add $t1, $s1, $zero
      add $t2, $t0, $t1
      add $t3, $t1, $t2
      add $t4, $t2, $t3
      add $t5, $t3, $t4
      add $t6, $t4, $t5
      add $t7, $t5, $t6
      addi    $a0, $t7, 0	#puts total value into $a0 to be printed
      li      $v0, 1		#puts 1 into $v0 which will print $a0 in the syscall
      syscall			#prints the value in $a0 with this syscall
      li      $v0, 10		#puts 10 into $v0 to terminate execution
      syscall			#exits and returns control back to os
