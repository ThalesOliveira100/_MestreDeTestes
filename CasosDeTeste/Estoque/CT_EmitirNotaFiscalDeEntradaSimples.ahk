#Requires AutoHotkey v2.0
#Include ../../Bibliotecas/Lib_NotaEntrada.ahk
#Include ../../Bibliotecas/Lib_Sistema.ahk

try {
    WinActivate("DYGNUS PREMIER")
    AcessarTelaPorCodigo(324)

    dadosNota := Map(
        "estabelecimento", 1,
        "fornecedor", 2,
    )

    resultado := InformarDadosGeraisDaNotaEntrada(dadosNota)
    
    if (resultado == "FALHA") {
        MsgBox("Falha durante a inclusão de dados gerais da nota", "atenção", 16)
        ExitApp(500)
    }

} catch as e {
    MsgBox("Falha ocorrida durante a emissão de nota de entrada: " . e.Message)
    ExitApp(1)
}

ExitApp(0)