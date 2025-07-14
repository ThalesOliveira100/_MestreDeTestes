#Requires AutoHotkey v2.0
SetTitleMatchMode(1) ; Define que a busca pelo título do programa deve começar com o indicado.

; =================================================================================
; || BIBLIOTECA DE FUNÇÕES DA ROTINA PEDIDO DE VENDA                              ||
; =================================================================================
; || Descrição: Contém as funções básicas para interação com a rotina de pedido   ||
; || de venda, tais como inserir produto, informar cliente, e outros.             ||
; =================================================================================


IncluirDadosGeraisPedido(estabelecimento, operacao, cliente, vendedor, informaAmbiente:=False) {
    try {
        SendInput("{F3}")
        SendInput(estabelecimento . "{Tab}")
        Sleep(500)

        if (informaAmbiente == true) {
            MsgBox("Selecionado para informar o ambiente.`n`nFuncionalidade ainda não está pronta.", "Atenção!", 64)
            WinActivate("DYGNUS PREMIER")
            SendInput("{Enter}")
        } else {
            SendInput("{Enter}")
        }

        SendInput("^A")
        SendInput(operacao . "{Tab}")
        Sleep(500)

        SendInput(cliente . "{Tab}{Tab}")
        Sleep(500)

        if (WinWait("Posição Financeira do Cliente")) {
            SendInput("{F12}")
            SendInput("{Tab}")
        }

        SendInput(vendedor . "{Tab}")
        Sleep(500)

        SendInput("{Enter}")
    } catch as e {
        MsgBox("Erro ao incluir dados gerais do pedido: " . e.Message, "ATENÇÃO", 16)
        return "ERRO"
    }
    return "SUCESSO"
}


FecharInformacaoVendedorExterno() {
    try {
        hWnd := WinWait("Vendedor Externo")
        if (hWnd) {
            WinActivate("ahk_id " . hWnd)
            WinWait("ahk_id " . hWnd)
            ControlClick("TBitBtn3", "Vendedor Externo")
            WinWaitClose("ahk_id " . hWnd, , 3)
        }
    } catch as e {
        MsgBox("Erro ao fechar informação do vendedor externo: " . e.Message, "ATENÇÃO", 16)
        return "ERRO"
    }
    return "SUCESSO"
}


InserirItemNoPedido(tipo, produto, quantidade, preco, valorDesconto) {
    try {
        Sleep(1500)

        if (tipo != "P") {
            SendInput("!{Left}")
            SendInput(tipo . "{Tab}")
            Sleep(500)
        } else {
            SendInput("{Enter}{Enter}")
        }

        SendInput(produto . "{Tab}")
        Sleep(500)

        SendInput(quantidade . "{Tab}")
        Sleep(500)

        SendInput(preco . "{Tab}{Tab}")
        Sleep(500)

        ; Informa desconto, se o valor passado for maior que 0
        if (valorDesconto != 0) {
            SendInput(valorDesconto)
        }
        SendInput("{Tab}")

        ; Validações de produtos
        if (WinWait("Assistente do Sistema")) {
            try {
                SendInput("{Enter}")
            } catch Error as e {
                MsgBox(e.Message)
            }
        }

    } catch as e {
        MsgBox("Erro ao inserir item no pedido: " . e.Message, "ATENÇÃO", 16)
        return "ERRO"
    }
    return "SUCESSO"  
}


GravarPedido(informaFinanceiro := false, imprimePedido := false){
    try {
        SendInput("{F9}")
        Sleep(500)

        if (WinWait("Dados Adicionais do Pedido")) {
            SendInput("{F12}")
        }

        Sleep(500)

        if (WinWait("Assistente do Sistema")) {
            SendInput("{Enter}")
        }
        Sleep(500)

        SendInput("{Tab}{Enter}")
        Sleep(500)
        SendInput("{Tab}{Enter}")
        Sleep(500)
        SendInput("{Tab}{Enter}")
        Sleep(500)

        ; ; Validação Financeiro
        ; if (informaFinanceiro == false) {
        ;     SendInput("{Tab}{Enter}")
        ; }

        ; ; Validação Impressão
        ; if(imprimePedido == false) {
        ;     SendInput("{Tab}{Enter}")
        ; } 

    } catch as e {
        MsgBox("Erro ao inserir item no pedido: " . e.Message, "ATENÇÃO", 16)
        return "ERRO"
    }
    return "SUCESSO"
}
