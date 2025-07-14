#Requires AutoHotkey v2.0
#Include ../../../Bibliotecas/Lib_Sistema.ahk
#Include ../../../Bibliotecas/Lib_PedidoVenda.ahk


try {
    LaunchApp()
    Login()
    AcessarTelaPorCodigo(403)
    IncluirDadosGeraisPedido(1, 99, 100, 15)
    FecharInformacaoVendedorExterno()

    ; Confirma a data do pedido com a data atual.
    SendInput("{Enter}")

    InserirItemNoPedido("P", 100, 1, 50, 0)
    InserirItemNoPedido("S", 2675, 1, 100, 0)
    Sleep(500)
    SendInput("{Enter}")

    ; Tem algum erro de foco quando o serviço é informado antes do produto.

    GravarPedido()
    FecharSistema()
} catch as e {
    MsgBox("Erro durante execução do teste: " . e.Message, "atenção", 64)
    ExitApp(1)
}

ExitApp()
