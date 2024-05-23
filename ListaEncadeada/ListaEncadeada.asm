.data
menu_string:
    	.asciz "\n# Menu\n#1 - Inserir elemento na lista\n#2 - Remover elemento da lista por indice\n#3 - Remover elemento da lista por valor\n#4 - Mostrar todos os elementos da lista\n#5 - Mostrar estatisticas\n#6 - Sair do programa\nEscolha: "
selecao_menu:
    	.word 0
head:
	.word 0
.text

main:
	#imprime menu
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
    	li t1, 1
    	beq t0, t1, call_inserir_inteiro
    	li t1, 2
    	beq t0, t1, call_remover_por_indice
    	li t1, 3
    	beq t0, t1, remover_por_valor
    	li t1, 4
    	beq t0, t1, call_imprime_lista
    	li t1, 5
    	beq t0, t1, call_estatistica
    	li t1, 6
    	beq t0, t1, sair_programa

 	#caso alguma opcao invalida seja selecionada imprime o menu novamente
    	j main
call_inserir_inteiro:
	jal inserir_inteiro
	j main
inserir_inteiro:
    	# ...
    	ret
call_remover_por_indice:
	jal remover_por_indice
	j main
remover_por_indice:
    	# ...
    	ret
call_remover_por_valor:
	jal remover_por_valor
	j main
remover_por_valor:
    	# ...
	ret
call_imprime_lista:
	jal imprime_lista
	j main
imprime_lista:
    	# ...
    	ret
call_estatistica:
	jal estatistica
	j main
estatistica:
    	# ...
    	ret
sair_programa:
    	li a7, 10
    	ecall