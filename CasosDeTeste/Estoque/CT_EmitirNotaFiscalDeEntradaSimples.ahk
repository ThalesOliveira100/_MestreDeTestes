#Requires AutoHotkey v2.0
#Include ../../Bibliotecas/Lib_NotaEntrada.ahk
#Include ../../Bibliotecas/Lib_Sistema.ahk

try {
    WinActivate("DYGNUS PREMIER")
    AcessarTelaPorCodigo(324)

    dadosNota := Map(
        "estabelecimento", 1,
        "fornecedor", 2,
        "tipoDocumento", 15,
    )

    resultado := InformarDadosGeraisDaNotaDeEntrada(dadosNota)
    if (resultado == "FALHA") {
        MsgBox("Falha durante a inclusão de dados gerais da nota: " . e.Message, "atenção", 16)
        ExitApp(500)
    }

    valoresNota := Map(
        "VlrTotalProdutos", 75,
    )

    resultado := InformarValoresDaNotaDeEntrada(valoresNota)
    if (resultado == "FALHA") {
        MsgBox("Falha durante a inclusão dos valores na nota de entrada", "Atenção!", 16)
        ExitApp(500)
    }

    resultado := InformarProdutosDaNotaDeEntrada(500, 2102)
    resultado := InformarProdutosDaNotaDeEntrada(100, 2102)
    resultado := InformarProdutosDaNotaDeEntrada(90, 2102)
    if (resultado == "FALHA") {
        MsgBox("Falha durante a inclusão da definição fiscal do item 2: " . e.Message, "Atenção!", 16)
        ExitApp(500)
    }

    resultado := GravarNotaFiscalDeEntrada()
    if (resultado == "FALHA") {
        MsgBox("Falha durante a gravação de nota fiscal de entrada 2: " . e.Message, "Atenção!", 16)
        ExitApp(500)
    }

} catch as e {
    MsgBox("Falha ocorrida durante a emissão de nota de entrada: " . e.Message)
    ExitApp(1)
}

ExitApp(0)