;	---------------
;		-	AOC_ICMC OS -
;		---------------
;
; Sistema operacional por Aria de Oliveira Cardoso
;
; Baseado no programa simulador de editor de texto,
; por Nathan Oliveira
;
; Obs: O programa encerra ao se digitar 'esc'

jmp 30002

; Padding (enchimento) necessário para reservar região de memória (aqui ocupada pelas strings 000), para o programa a ser carregado.

padding: var #30000

comando: string "                        "
boasvindas: string "Bem-vindo ao AOC_ICMC OS!"
usage: string "] para enter, [ para backspace"
cnf: string "Comando nao encontrado."
prompt: string "> "
com1: string "run"
com2: string "exit"

main:

loadn r0, #0 ; Carrega no registrador a posição inicial da primeira letra da string
loadn r1, #boasvindas ; Carrega a string de abertura a ser impressa
loadn r2, #3328 ; Carrega a cor da mensagem de abertura

call Imprimestring ; Impremestring(posicaoinicial,endereçostring,cor)

loadn r3, #40
add r0, r0, r3 ; Pula linha
loadn r2, #0
loadn r1, #usage
call Imprimestring

add r0, r0, r3 ; Pula linha
add r0, r0, r3
loadn r1, #prompt
loadn r2, #0
call Imprimestring

loadn r0, #122 ; Carrega onde o usuário vai começar a digitar
loadn r1, #0 ; Carrega a cor da letra do usuário

call Digitando ; Digitando(posicaoinicial,cor)

halt

Imprimestring:
	push r0 ; Preserva o valor de r0,r1 e r2 para não alterá-lo na main, além de r3 e r4 que poderiam estar sendo usados lá e serão necessários nessa subrotina
	push r1
	push r2
	push r3
	push r4

	loadn r3, #'\0' ;Condição de parada de impressão de string
	
Imprimestringloop:
	loadi r4,r1		;Faz um load do conteudo apontado por r1 no registrador r4
	cmp r4,r3 		
	jeq Imprimestringfim	;Ve se o caractere atual é o /0
	add r4, r4,r2			;Faz a dinamica da cor (= O + 256 é porque todos os ascii de cada cor estão enfileirados, ao somar 256 ele pega o mesmo char só que de outra cor, Obs: tem um mod implementado, então depois do aqua vem branco denovo )
	outchar r4, r0			;Escreve o caracter no endereço de r1 na posição r0 da tela
	inc r0					;Vai para proxima posição da tela
	inc r1					;Vai para a proxima posição do vetor
	jmp Imprimestringloop
	
Imprimestringfim:

	pop r4 ; Devolve os valores originais aos registradores e volta para onde foi chamada
	pop r3
	pop r2
	pop r1
	pop r0
	rts

Digitando: ; A função digitando faz o controle dos caracteres na tela enquanto o usuário digita
	push r0
	push r1
	push r2
	push r3
	push r4
	push r5
	push r6
	push r7
	mov r2,r0 ;Reserva em r2 a posicao inicial e r2 será a posição corrente
	loadn r3, #'[' ; codigo ascii do backspace
	; loadn r4, #'&' ; codigo ascii do esc 27 - ~ 127 - como o simulador já sai com esc para testes esta o &
	loadn r4, #0 ; Contador do número de caracteres no comando
	loadn r5, #' '; codigo ascii do espaço
	loadn r6, #comando ; Move endereço da string de input para r6
	loadn r7, #']' ; codigo ascii do enter
	
	DigitandoLoop:
	
	call RecebeChar ; atualiza r0 com o char inserido pelo usuario
	storei r6, r0 ; Move char digitado na memória que salva o comando
	loadn r0, #boasvindas ; Carrega fim da string de comando
	cmp r6, r0 ; Checa tamanho da string comando contra overflow
	loadi r0, r6;
	jeq skip1 ; Pula incrementação caso comando atinja limite de tamanho
	inc r6 ; Incrementa ponteiro do comando
	skip1:
	cmp r0,r3 ; verifica se é um enter, delete ou &
	jeq DigitandoApagar
	;cmp r0,r4
	;jeq DigitandoFim
	cmp r0,r7
	jeq DigitandoEnter
	
	outchar r0, r2
	inc r2
	jmp DigitandoLoop
	
	DigitandoEnter:
		;Para pular para a proxima linha, vê quantos caracteres faltam para acabar a linha e pula eles
		push r0
		push r1
		push r3
		push r4
		push r5
		push r7

		loadn r7, #40 ; Move tamanho da linha pra r7

		; Pula linha
			mod r1,r2,r7 ; pega em mod a posição atual da linha
			sub r0,r7,r1 ; verifica quantos chars faltam para o fim da linha
			add r2,r2,r0 ; pula os caracteres

		loadn r6, #comando ; Move r6 para início da string de input
		loadn r3, #com1 ; Carrega string do comando1
		loadn r4, #0 ; ; Carrega variavel de tamanho atual da string comando1

		dec r3 ; Decrementa ponteiros para entrar no trecho seguinte incrementando-os
		dec r6
		loop_com1: ; Faz checagem de comando
			inc r3 ; Incrementa ponteiro para string comando
			inc r6 ; Incrementa ponteiro para string input
			push r3 ; Salva r3 para usar com o cmp temporariamente
			loadn r3, #3 ; Carrega tamanho total da string comando - MUDAR CASO MUDE COMANDO
			cmp r4, r3 ; Checa fim da string comando
			jeq loadprog ; Pula para função de carregar programa
			inc r4 ; Aumenta tamanho checado da string
			pop r3 ; Recupera r3
			loadi r5, r6 ; Carrega conteudo da string input para comparar
			loadi r0, r3 ; Carrega conteudo da string comando para comparar
			cmp r0, r5 ; Compara as duas
			jeq loop_com1 ; Vai para proxima letra

		loadn r6, #comando
		loadn r3, #com2
		loadn r4, #0
		dec r3;
		dec r6;
		loop_com2:
			inc r3 ; Incrementa ponteiro para string comando
			inc r6 ; Incrementa ponteiro para string input
			push r3 ; Salva r3 para usar com o cmp temporariamente
			loadn r3, #4 ; Carrega tamanho total da string comando - MUDAR CASO MUDE COMANDO
			cmp r4, r3 ; Checa fim da string comando
			jeq nao_pula_halt ; Termina programa
			inc r4 ; Aumenta tamanho checado da string
			pop r3 ; Recupera r3
			loadi r5, r6 ; Carrega conteudo da string input para comparar
			loadi r0, r3 ; Carrega conteudo da string comando para comparar
			cmp r0, r5 ; Compara as duas
			jeq loop_com2 ; Vai para proxima letra

			jmp pula_halt
			nao_pula_halt:
			halt
			pula_halt:

		; Imprime erro
			push r0
			mov r0, r2 ; Carrega posicao a ser escrita a mensagem como linha atual
			push r1
			push r2
			loadn r1, #cnf ; Carrega a string a ser impressa
			loadn r2, #3328 ; Carrega a cor da mensagem
			call Imprimestring
			pop r2
			pop r1
			pop r0

		ImprimePrompt:
			push r0
			push r1
			mov r0, r2 ; r0 e a posicao a ser escrita a string
			push r2
			add r0, r0, r7 ; Pula linha
			loadn r1, #prompt ; r1 e a string a ser impressa
			loadn r2, #0 ; r0 e a cor da mensagem
			call Imprimestring
			pop r2
			add r2, r2, r7
			inc r2
			inc r2
			pop r1
			pop r0

		; Fim da funcao DigitandoEnter
			loadn r6, #comando ; Retorna r6 para início da string de comando para esperar novo comando
			pop r7
			pop r5
			pop r4
			pop r3	
			pop r1
			pop r0
			jmp DigitandoLoop
	
	DigitandoApagar:
	dec r2
	outchar r5, r2
	jmp DigitandoLoop
	
	DigitandoFim:
	pop r7
	pop r6
	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts

loadprog: ; Nao precisa salvar os registradores pois a funçao carrega outro programa

	loadn r3, #0 ; Usado como flag para jmp
	loadn r4, #6971 ; Carrega em r4 o fim do programa em disco
	loadn r6, #0 ; Carrega começo do programa em disco para r6
	loadn r7, #0; Carrega endereço da RAM onde o programa deve estar

	loopprog:
		loadi2 r5, r6 ; Carrega conteúdo da memória de disco para r5
		storei r7, r5 ; Carrega conteúdo de r5 para memória RAM
		inc r6 ; Incrementa endereço da memória de disco
		inc r7 ; Incrementa endereço da memória RAM na qual o programa é carregado
		cmp r6, r4 ; Ve se o programa em disco ja foi carregado por completo
		jne loopprog ;

	jmp 0 ; Pula a execução para novo programa.

RecebeChar: ;a função RecebeChar é um loop que só se encerra ao receber uma entrada do usuario devolvendo o código ascii dessa tecla em r0
	push r1
	loadn r1, #255
	RecebeCharLoop:
	inchar r0 ; o Inchar devolve 255 se nenhuma tecla esta sendo precionada, então ao esperar uma tecla, ele fica testando até alguem apertar algo
	cmp r0, r1
	jeq RecebeCharLoop
	;breakp
	pop r1
	rts

end:
	halt
