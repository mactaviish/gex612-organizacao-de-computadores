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
msg_maior_valor:
	.asciz "\nMaior Valor: "
msg_menor_valor:
	.asciz "\nMenor Valor: "
msg_qtd_insercoes:
	.asciz "\nQuantidade de Insercoes: "			
msg_qtd_remocoes:
	.asciz "\nQuantidade de remocoes: "			
msg_lista_vazia:
	.asciz "\nA lista está vazia "			
quebra_linha:
	.asciz "   "
selecao_menu:
    	.word 0
head:
	.word 0
tail:
	.word 0
insercoes:
	.word 0
qtd:
	.word 0
anterior:
	.word 0
maior:
	.word 0
menor:
	.word 0
remocoes:
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
 #BEGIN INSERCAO
inserir_inteiro_call:
	jal ler_valor
	jal inserir_inteiro
	j verifica_retorno
inserir_inteiro:
	mv s0, a0 #head
	addi s4, s4, 0
	#alloca memoria
	li a0, 8
	li a7, 9
	ecall
	lw t4, 0(s0) #atual head
	beq t4, zero, inserir_cabeca #se a lista estiver vazia, insere na ponta
	lw s1, 0(t4)
	blt a1, s1, inserir_cabeca #se o valor for menor que o valor presente no head, inserir o novo valor no head
inserir_loop:
	lw t6, 4(t4) #carrega o proximo
	beqz t6, inserir_fim
	lw t5, 0(t6) #carrega o proximo valor
	bge a1, t5, continuar_insercao #se o novo valor for maior ou igual ao proximo, continua percorrendo
	sw t6, 4(a0) #adiciona no meio
	sw a0, 4(t4) #adiciona no meio
	sw a1, 0(a0) #adiciona no meio
	addi s4, s4, 1 #contador do indice
	j update_estatisticas
inserir_cabeca:	
	sw t4, 4(a0) #aponta para o proximo, usando o endereco do head atual
	sw a1, 0(a0) #adiciona o valor inserido
	sw a0, 0(s0) #aponta o novo head
	
	la s3, menor #salva maior
	sw a1, 0(s3)

	addi s4, s4, 1 #contador do indice
	j update_estatisticas
continuar_insercao:
	mv t4, t6
	addi s4, s4, 1 #contador do indice
	j inserir_loop
inserir_fim:
	sw a1, 0(a0)
	sw zero, 4(a0)
	sw a0, 4(t4)
	
	lw t6, 4(t4) #carrega o proximo
	
	la s3, maior #salva maior
	lw s1, 0(t6)
	sw s1, 0(s3)
	
	addi s4, s4, 1 #contador do indice
	j update_estatisticas
update_estatisticas:
	lw t6, insercoes
	addi t6, t6, 1
	la t1, insercoes
	sw t6, 0(t1)
	
	lw t6, qtd
	addi t6, t6, 1
	la t1, qtd
	sw t6, 0(t1)
	mv t6, s4
	ret
#END INSERCAO
#BEGIN REMOVER POR INDICE
remover_por_indice_call:
	jal ler_valor
	jal remover_por_indice
	j verifica_retorno
remover_por_indice:
	lw t3, 0(a0)
    	beqz t3, erro_remocao #lista vazia, nao é possivel remover
    	mv t4, zero #contador de indices
    	beq a1, zero, remove_primeiro
remove_loop:
	lw t5, 4(t3)
	addi t4, t4, 1
	beq t4, a1, remove_elemento
	beqz t5, erro_remocao #indice nao existe na lista
	mv t3, t5
	j remove_loop
remove_primeiro:
	lw t5, 4(t3) #remove primeiro
	sw t5, 0(a0)
	j update_remocao
remove_elemento:
	lw t6, 4(t5)
	sw t6, 4(t3)
update_remocao:
	lw t0, remocoes
	addi t0, t0, 1
	la t1, remocoes
	sw t0, 0(t1)
	
	lw t0, qtd
	addi t0, t0, -1
	la t1, qtd
	lw t0, 0(t1)
	
	lw t6, 0(t3)
	ret
erro_remocao:
	li t6, -1
	ret
removido_ultimo:
	lw t6, 0(t3)
	ret

#END REMOVER POR INDICE
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
	j menu
imprime_lista:
	lw t2, 0(a0)
	beqz t2, padrao_vazia
laco_impressao:	
	beqz t2, fim_laco	#laco impressao
	li a7, 1
	lw a0, 0(t2)
	ecall
	li a7, 4
	la a0, quebra_linha
	ecall
	lw t2, 4(t2)
    	j laco_impressao
fim_laco:
    	ret
estatistica_call:
	jal seta_head
	jal estatistica	
	j menu
estatistica:
	la t1, head
	lw t1, 0(t1)
	beqz t1, padrao_vazia
	la a0, msg_maior_valor
	li a7, 4
	ecall	
	la t0, maior
	lw a0, 0(t0)
	li a7, 1
	ecall
	
	la a0, msg_menor_valor
	li a7, 4
	ecall
	la t0, menor
	lw a0, 0(t0)
	li a7, 1
	ecall
	
	la a0, msg_qtd_insercoes
	li a7, 4
	ecall
	la t0, insercoes
	lw a0, 0(t0)
	li a7, 1
	ecall
	
	la a0, msg_qtd_remocoes
	li a7, 4
	ecall
	la t0, remocoes
	lw a0, 0(t0)
	li a7, 1
	ecall
	
	ret
padrao_vazia:
	la a0, msg_lista_vazia
	li a7, 4
	ecall
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
verifica_retorno:
	add s4, zero, zero
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
	mv t6, zero
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
