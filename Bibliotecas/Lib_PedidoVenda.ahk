#Requires AutoHotkey v2.0
SetTitleMatchMode(1) ; Define que a busca pelo título do programa deve começar com o indicado.

; =================================================================================
; || BIBLIOTECA DE FUNÇÕES DA ROTINA PEDIDO DE VENDA                              ||
; =================================================================================
; || Descrição: Contém as funções básicas para interação com a rotina de pedido   ||
; || de venda, tais como inserir produto, informar cliente, e outros.             ||
; =================================================================================


IncluirDadosGeraisPedido(estabelecimento, operacao, cliente, vendedor, informaAmbiente:=False) {
    ; classJanelaPedido := "Tfrm_PedidoVenda1"
    classCampoEstabelecimento := "TDBEdit15"
    classCampoOperacao := "TDBEdit11"
    classCampoCliente := "TDBEdit13"
    classCampoVendedor := "TDBEdit12"

    try {
        ControlClick(classCampoEstabelecimento)
        SendInput(estabelecimento)

        if (informaAmbiente == true) {
            MsgBox("Selecionado para informar o ambiente.`n`nFuncionalidade ainda não está pronta.", "Atenção!", 64)
        } else {
            SendInput("{Enter}")
        }

        ControlClick(classCampoOperacao, , , , 2)
        SendInput(operacao)

        ControlClick(classCampoCliente, , , , 2)
        SendInput(cliente)

        ControlClick(classCampoVendedor, , , , 2)
        SendInput(vendedor)

    } catch as e {
        MsgBox("Erro ao incluir dados gerais do pedido", "ATENÇÃO", 16)
        return "ERRO"
    }
    return "SUCESSO"
}


FecharInformacaoVendedorExterno() {
    ; classAvisoVendedorExterno := "Tfrm_Solicita_Vendedor_Externo"

    try {
        hWnd := WinWait("Vendedor Externo")
        if (hWnd) {
            WinActivate("ahk_id " . hWnd)
            WinWait("ahk_id " . hWnd)
            ControlClick("TBitBtn3", "Vendedor Externo")
            WinWaitClose("ahk_id " . hWnd, , 3)
        }
    } catch as e {
        MsgBox("Erro ao fechar informação do vendedor externo", "ATENÇÃO", 16)
        return "ERRO"
    }
    return "SUCESSO"
}


InserirItemNoPedido(tipo, produto, quantidade, preco) {
    classTipo := "TMaskEdit1"
    classProduto := "TMaskEdit2"
    classQuantidade := "TJvDBCalcEdit7"
    classPreco := "TJvDBCalcEdit6"

    try {
        ControlClick(classTipo, , , , 2)
        SendInput(tipo)

        ControlClick(classProduto)
        SendInput(produto)

        ControlClick(classQuantidade)
        SendInput(quantidade)

        ControlClick(classPreco)
        SendInput(preco)

    } catch as e {
        MsgBox("Erro ao inserir item no pedido", "ATENÇÃO", 16)
        return "ERRO"
    }
    return "SUCESSO"  
}
