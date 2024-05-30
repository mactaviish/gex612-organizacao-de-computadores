.data
menu_string:
    	.asciz "\n# Menu\n#1 - Inserir elemento na lista\n#2 - Remover elemento da lista por indice\n#3 - Remover elemento da lista por valor\n#4 - Mostrar todos os elementos da lista\n#5 - Mostrar estatisticas\n#6 - Sair do programa\nEscolha: "
msg_inserir_valor: 
	.asciz "\nDigite o valor:\n"
msg_erro: 
	.asciz "\nOcorreu um erro\n"
selecao_menu:
    	.word 0
head:
	.word 0
tail:
	.word 0
.text

main:
	#imprime menu
menu:
	la a0, menu_string      
	li a7, 4               
	ecall
	# Le a opcao selecionada pelo usuario
	li a7, 5                
	ecall
    	la t1, selecao_menu      
    	sw a0, 0(t1)            
    	lw t0, 0(t1)
	
    	#chama a funcao selecionada pelo usuario
   	li t1, 4
    	beq t0, t1, imprime_lista
    	li t1, 5
    	beq t0, t1, estatistica
    	li t1, 6
    	beq t0, t1, sair_programa
	jal ler_valor
    	li t1, 1
    	beq t0, t1, inserir_inteiro
    	li t1, 2
    	beq t0, t1, remover_por_indice
    	li t1, 3
    	beq t0, t1, remover_por_valor
 	#caso alguma opcao invalida seja selecionada imprime o menu novamente
    	j menu
inserir_inteiro:
	sw s0, 0(a0) #inicio da lista	
	li a0, 8
	li a7, 9
	ecall #aqui vai retornar em a0 a posicao de memoria alocada
	beq s0, zero, tratar_lista_vazia
	#lw s1, tail	
	#sw s1, 0(t5)
	#sw a1, 0(s1)
	#sw zero, 4(s1)
    	li t6, -1
    	j verifica_retorno
tratar_lista_vazia:
	mv s0, a0
	la t4, head
	la t5, tail
	sw s0, 0(t4)
	sw a1, 0(s0)
	sw zero, 4(s0)
	li t6, 0 #indice retornado na funcao 
	j verifica_retorno
remover_por_indice:
    	# ...
    	li t6, -1
    	j verifica_retorno
remover_por_valor:
    	# ...
    	mv t6, a1
    	j verifica_retorno
imprime_lista:
    	# ...
    	j menu
estatistica:
    	# ...
    	j menu
ler_valor:
	la a0, msg_inserir_valor      
	li a7, 4               
	ecall
	# Le a opcao selecionada pelo usuario
	li a7, 5                
	ecall
	mv a1, a0
	la a0, head
	ret
verifica_retorno:
	blt t6, zero, retorno_com_erro
	mv a0, t6
	li a7, 1
	ecall
	j menu	
retorno_com_erro:
	la a0, msg_erro      
	li a7, 4               
	ecall
	j menu
sair_programa:
    	li a7, 10
    	ecall
