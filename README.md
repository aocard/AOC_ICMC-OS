# AOC_ICMC OS
Sistema operacional para o processador ICMC

Vídeo de demo:
	https://www.youtube.com/watch?v=FjXdYv4Hh0c

O sistema suporta dois comandos atualmente:

	run: Carrega programa da memória de disco na memória RAM e chaveia execução para ele

	exit: Termina o programa com halt

Modificações feitas no simulador e montador:

	Adicionada uma segunda memória, que atua como memória de disco

	Simulador lê dois arquivos agora, com nomes passador pelos parâmetros 1 e 2, respectivamente. Arquivos padrão, caso não hajam argumentos, são cpuram.mif e cpuhdd.mif

	(Vide Manuals_MEM2/Arquitetura.png para imagem da arquitetura)

	Adicionadas instruções de:
		load ( "load rx, #numero", equivale a "rx <- MEM2[numero]" ),
		load indireto ( "loadi rx, ry", equivale a "rx <- MEM2[ry]" ),
		store ( "store #numero, rx", equivale a "MEM2[rx] <- numero" ),
		store indireto ( "storei rx, ry", equivale a "MEM2[rx] <- ry" )

Link do repo atual:
  https://github.com/aocard/AOC_ICMC-OS

Link do repo original:
  https://github.com/simoesusp/Processador-ICMC

Crédito dos códigos utilizados:

	Eduardo do Valle Simões (Projeto do processador)

	Breno Cunha Queiroz (Simulador OpenGL)

	Maria Eduarda Kawakami (Simulador OpenGL)

	Nathan Oliveira (Código original para ler teclado)

	Guinevere Larsen (Montador Linux)
