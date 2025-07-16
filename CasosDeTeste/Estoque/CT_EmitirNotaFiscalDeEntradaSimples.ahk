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

    resultado := InformarDadosGeraisDaNotaDeEntrada(dadosNota)
    if (resultado == "FALHA") {
        MsgBox("Falha durante a inclusão de dados gerais da nota", "atenção", 16)
        ExitApp(500)
    }

    valoresNota := Map(
        "VlrTotalProdutos", 1250,
    )
    resultado := InformarValoresDaNotaDeEntrada(valoresNota)
    if (resultado == "FALHA") {
        MsgBox("Falha durante a inclusão dos valores na nota de entrada", "Atenção!", 16)
        ExitApp(500)
    }

    resultado := InformarProdutosDaNotaDeEntrada(500, 2102)


} catch as e {
    MsgBox("Falha ocorrida durante a emissão de nota de entrada: " . e.Message)
    ExitApp(1)
}

ExitApp(0)