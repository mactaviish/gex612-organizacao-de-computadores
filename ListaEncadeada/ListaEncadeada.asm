.data
menu_string:
    	.asciz "\n\n# Menu\n#1 - Inserir elemento na lista\n#2 - Remover elemento da lista por indice\n#3 - Remover elemento da lista por valor\n#4 - Mostrar todos os elementos da lista\n#5 - Mostrar estatisticas\n#6 - Sair do programa\nEscolha: "
msg_inserir_valor: 
	.asciz "\nDigite o valor:\n"
msg_erro: 
	.asciz "\nOcorreu um erro\n"
msg_inserido:
	.asciz "\nInserido com sucesso!\nIndice: "
msg_removido_indice:
	.asciz "\nRemovido com sucesso!\nValor: "
msg_removido_valor:
	.asciz "\nRemovido com sucesso!\nIndice: "
quebra_linha:
	.asciz "   "
selecao_menu:
    	.word 0
head:
	.word 0
tail:
	.word 0
qtd_lista:
	.word 0
anterior:
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
    	beq t0, t1, imprime_lista_call
    	li t1, 5
    	beq t0, t1, estatistica_call
    	li t1, 6
    	beq t0, t1, sair_programa

    	li t1, 1
    	beq t0, t1, inserir_inteiro_call
    	li t1, 2
    	beq t0, t1, remover_por_indice_call
    	li t1, 3
    	beq t0, t1, remover_por_valor_call
 	#caso alguma opcao invalida seja selecionada imprime o menu novamente
    	j menu
inserir_inteiro_call:
	jal ler_valor
	jal inserir_inteiro
	j verifica_retorno
inserir_inteiro:
	mv s0, a0 #head
	#alloca memoria
	li a0, 8
	li a7, 9
	ecall
	#a0 vai ter a nova posicao de memoria
	#sw a1, 0(a0) -  sempre vai executar esta linha
	lw s0, 0(s0)
	beq s0, zero, lista_vazia
laco_lista:
	#s0 contem HEAD 
	la t2, anterior
	lw s0, 0(t2) #salvando o anterior
	lw t4, 0(s0)

	bge a1, s0, proximo	
	ret
proximo:
	sw a0, 4(s0)
	sw a1, 0(a0)
	sw zero, 4(a0)
	lw s0, 4(s0) #NEXT
	j laco_lista
lista_vazia:
	la t1, head
	sw a0, 0(t1)
	sw a1, 0(a0)
	sw zero, 4(a0)
	ret
remover_por_indice_call:
	jal ler_valor
	jal remover_por_indice
	j verifica_retorno
remover_por_indice:
    	# ...
    	li t6, -1
	ret
remover_por_valor_call:
	jal ler_valor
	jal remover_por_valor
	j verifica_retorno
remover_por_valor:
    	# ...
    	mv t6, a1
	ret
imprime_lista_call:
	jal seta_head
	jal imprime_lista
	j verifica_retorno
imprime_lista:
	lw t0, 0(a0)
laco_imprecao:	#laco impressao
	lw a6, 0(t0)
	beq a6, zero, fim_laco	
	li a7, 1
	mv a0, a6
	ecall
	li a7, 4
	la a0, quebra_linha
	ecall
	addi t0, t0, 8
    	j laco_imprecao
fim_laco:
    	j menu
estatistica_call:
	jal seta_head
	jal estatistica
	j verifica_retorno
estatistica:
    	# ...
    	ret
ler_valor:
	la a0, msg_inserir_valor
	li a7, 4
	ecall
	li a7, 5
	ecall
	mv a1, a0
seta_head:
	la a0, head
	ret
atualiza_qtd:
	lw t6, qtd_lista
	addi t6, t6, 1
	la t1, qtd_lista
	sw t6, 0(t1)
	ret
verifica_retorno:
	blt t6, zero, retorno_com_erro
	lw t0, selecao_menu
	li t1, 1
	beq t0, t1, inserido
	li t1, 2
	beq t0, t1, removido_indice
	li t1, 3
	beq t0, t1, removido_valor
inserido:
	la a0, msg_inserido
	j executa_retorno
removido_indice:
	la a0, msg_removido_indice
	j executa_retorno
removido_valor:
	la a0, msg_removido_valor
executa_retorno:
	li a7, 4
	ecall
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
