#Requires AutoHotkey v2.0
#Include Lib_Validacao.ahk

SetTitleMatchMode(1) ; Define que a busca pelo título do programa deve começar com o indicado.
; SetTimer(Sleep, 500)

; =================================================================================
; || BIBLIOTECA DE FUNÇÕES DA ROTINA NOTA DE ENTRADA                              ||
; =================================================================================
; || Descrição: Contém as funções básicas para interação com a rotina de nota de  ||
; || entrada. Tais como incluir produto, informar valor, informar dados gerais, ..||
; =================================================================================

InformarDadosGeraisDaNotaEntrada(params){
    try {
        estabelecimento     := params.Has("estabelecimento")    ? params["estabelecimento"]: 1
        fornecedor          := params.Has("fornecedor")         ? params["fornecedor"]: 2
        tipoDocumento       := params.Has("tipoDocumento")      ? params["tipoDocumento"]: 15
        numero              := params.Has("numero")             ? params["numero"]: ""
        serie               := params.Has("serie")              ? params["serie"]: ""
        tipoCadastro        := params.Has("tipoCadastro")       ? params["tipoCadastro"]: "F"

        SendInput(estabelecimento . "{Tab}")

        if (tipoCadastro != "F") {
            MsgBox("Tipo de cadastro diferente de F informado, script ainda não está preparado para isso")
            WinActivate("DYGNUS PREMIER")
        }

        SendInput(fornecedor . "{Tab}")
        SendInput(tipoDocumento . "{Tab}")

        if (numero == "") {
            numero := Random(1000, 99999)
        }

        SendInput(numero . "{Tab}")

        if (serie != "") {
            SendInput(serie)
        }

        SendInput("{Tab}{F3}")

        if (tipoDocumento == 15) {
            WinWait("Confirm")
            SendInput("{Enter}")

            if not WinWait("Informe o Número do DANFE", , 5) {
                MsgBox("A janela para informar o número do DANFE não foi exibida", "Erro de validação", 16)
                return "FALHA"
            }

            if not EncontrarNumeroDANFE() {
                return "FALHA"
            }
        }

    } catch as e {
        MsgBox("Erro na inclusão dos dados gerais da nota de entrada: " . e.Message)
        return "FALHA"
    }
    return "SUCESSO"

}


EncontrarNumeroDANFE() {
    tituloJanelaDANFE := "Informe o Número do DANFE"
    classCampoDANFE := "TMaskEdit1"
    classBotaoConfirmar := "TBitBtn1"

    ControlFocus(classCampoDANFE, tituloJanelaDANFE)
    SendInput("123456789")
    Sleep(500)

    Loop 10 {
        numeroFinal := A_Index - 1

        ControlFocus(classCampoDANFE, tituloJanelaDANFE)
        SendInput(numeroFinal)
        ControlClick(classBotaoConfirmar, tituloJanelaDANFE)

        if WinWait("Assistente do Sistema", , 1.5) {
            SendInput("{Enter}")
            WinWaitClose("Assistente do Sistema", , 2)
            SendInput("{Left}")
            Sleep(500)
        } else {
            return true
        }
    }

    MsgBox("Nenhum dos 10 números finais para a DANFE foi aceito")
    return False
}

