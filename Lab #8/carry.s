	.text

#li	$v0, 1
addu	$t0, $t3, $t4
sltu	$t1, $t0, $t3
beq	$t1, 1, overflow
sltu	$t1,$t0, $t4
beq	$t1, 1, overflow
#li	$a0, 0 #no overflow, print 0
#syscall
j	done
overflow:
li	$t2, 1
#li	$a0, 1	#overflow print 1
#syscall	

done:

