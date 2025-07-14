#Requires AutoHotkey v2.0
#Include ../../../Bibliotecas/Lib_Sistema.ahk
#Include ../../../Bibliotecas/Lib_PedidoVenda.ahk

; Criar funções de inclusão de pedidos.

resultado := LaunchApp()
if (resultado == "FALHA") {
    MsgBox("Erro identificado, o script será encerrado.", "ERRO na INICIALIZAÇÃO!", 16)
    ExitApp(1)
}

resultado := Login()
if (resultado == "FALHA") {
    MsgBox("Erro identificado, o script será encerrado.", "ERRO no LOGIN!", 16)
    ExitApp(1)
}

resultado := AcessarTelaPorCodigo(403)
if(resultado == "FALHA") {
    MsgBox("Erro identificado, o script será encerrado.", "ERRO no acesso da tela!", 16)
    ExitApp(1)
}

resultado := IncluirDadosGeraisPedido(1, 99, 100, 15)
if(resultado == "FALHA") {
    MsgBox("Erro identificado, o script será encerrado.", "ERRO na inclusão de dados gerais do pedido!", 16)
    ExitApp(1)
}

resultado := FecharInformacaoVendedorExterno()
if(resultado == "FALHA") {
    MsgBox("Erro identificado, o script será encerrado.", "ERRO ao fechar dados do VE do pedido!", 16)
    ExitApp(1)
}

; Confirma a data do pedido como a data atual.
SendInput("{Enter}")

resultado := InserirItemNoPedido("P", 100, 1, 100, 0)
resultado := InserirItemNoPedido("P", 100, 1, 100, 0)
resultado := InserirItemNoPedido("P", 100, 1, 100, 0)
resultado := InserirItemNoPedido("P", 100, 1, 100, 0)
resultado := InserirItemNoPedido("P", 100, 1, 100, 0)
resultado := InserirItemNoPedido("P", 100, 1, 100, 0)
if(resultado == "FALHA") {
    MsgBox("Erro identificado, o script será encerrado.", "ERRO na inclusão de produtos no pedido!", 16)
    ExitApp(1)
}

resultado := GravarPedido()
if(resultado == "FALHA") {
    MsgBox("Erro identificado, o script será encerrado.", "ERRO na gravação do pedido!", 16)
    ExitApp(1)
}

ExitApp()
