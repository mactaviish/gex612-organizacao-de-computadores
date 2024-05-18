.data
vetor:
	.word 5, 9, 1, 8, 7, 2, 4, 3, 10, 6
tamanho_vetor:
	.word 10
menor:
	.string "\nQuantidade elementos menores: "
indice:
	.string "\nÍndice maior diferença: "

.text
main:
	la a0, vetor
	lw a1, tamanho_vetor
	li a2, 5
qtd_comparacao:
	li t0, 0
	li s0, 0
	li s1, 0
	li t2, 0
loop:
	beq t0, a1, fim_loop
	lw t1, 0(a0)
	bge t1, a2, nao_eh_menor
eh_menor:
	addi s0, s0, 1
	sub t3, a2, t1
	ble t3, t2, nao_eh_menor
	mv s1, t0
	mv t2, t3
nao_eh_menor:
	addi a0, a0, 4
	addi t0, t0, 1
	j loop
fim_loop:
	mv a0, s0
	mv a1, s1
print:
	la a0, menor
	jal print_string
	mv a0, s0
	jal print_integer
	
	la a0, indice
	jal print_string
	mv a0, s1
	jal print_integer
print_string:
	li a7, 4
	ecall
	ret
print_integer:
	li a7, 1
	ecall
	ret
finalizar:
	li a7, 93
	ecall
