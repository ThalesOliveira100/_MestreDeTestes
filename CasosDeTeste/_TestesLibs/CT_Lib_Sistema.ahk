#Requires AutoHotkey v2.0
#Include ../../Bibliotecas/Lib_Sistema.ahk

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
if (resultado == "FALHA") {
    MsgBox("Erro identificado, o script será encerrado.", "ERRO na CONSULTA POR CÓDIGO!", 16)
    ExitApp()
}

; resultado := FecharSistema()
ExitApp()
