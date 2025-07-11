#Requires AutoHotkey v2.0
#Include ../../../Bibliotecas/Lib_Sistema.ahk
#Include ../../../Bibliotecas/Lib_PedidoVenda.ahk

; Criar funções de inclusão de pedidos.

resultado := LaunchApp()
if (resultado == "FALHA") {
    MsgBox("Erro identificado, o script será encerrado.", "ERRO na INICIALIZAÇÃO!", 16)
    ExitApp()
}

resultado := Login()
if (resultado == "FALHA") {
    MsgBox("Erro identificado, o script será encerrado.", "ERRO no LOGIN!", 16)
    ExitApp()
}

resultado := AcessarTelaPorCodigo(403)
if(resultado == "FALHA") {
    MsgBox("Erro identificado, o script será encerrado.", "ERRO no acesso da tela!", 16)
    ExitApp()
}

; WinWait("Tfrm_PedidoVenda1")
Sleep(1500)
resultado := ControlClick("TBitBtn37")

if(resultado == "FALHA") {
    MsgBox("Erro identificado, o script será encerrado.", "ERRO ao clicar no botão", 16)
    ExitApp()
}

resultado := IncluirDadosGeraisPedido(1, 99, 100, 15, false)
if(resultado == "FALHA") {
    MsgBox("Erro identificado, o script será encerrado.", "ERRO na inclusão de dados gerais do pedido!", 16)
    ExitApp()
}

resultado := FecharInformacaoVendedorExterno()
if(resultado == "FALHA") {
    MsgBox("Erro identificado, o script será encerrado.", "ERRO ao fechar dados do VE do pedido!", 16)
    ExitApp()
}

resultado := InserirItemNoPedido("P", 100, 1, 100)
if(resultado == "FALHA") {
    MsgBox("Erro identificado, o script será encerrado.", "ERRO na inclusão de produtos no pedido!", 16)
    ExitApp()
}

ExitApp()
