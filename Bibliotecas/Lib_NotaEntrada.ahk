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


/**
 * @description - InformarDadosGeraisDaNotaEntrada (params)
 * Informa os dados gerais da nota de entrada, conforme os valores padrões, ou informados nesta função.
 * 
 * @param params - Mapa da combinação dos seguintes paramentros, sendo completamente opcionais.
 * @param estabelecimento - Estabelecimento para inclusão da nota.
 * @param fornecedor - Fornecedor da nota.
 * @param tipoDocumento - Se informado como 15 irá informar a chave de acesso da nota.
 * @param numero - Numero da nota de entrada. Se não informado, o script gerará um número aleatório entre 1000 e 99999.
 * @param serie - Série da nota. Se não informado, o script irá pular o campo, deixando o valor padrão.
 * @param tipoCadastro - Tipo de cadastro "F" para fornecedor e "C" para cliente. (Sem suporte para clientes no momento).
 * 
 * @return {String} "SUCESSO" ou "FALHA"
 */
InformarDadosGeraisDaNotaEntrada(params){
    try {
        estabelecimento     := params.Has("estabelecimento")    ? params["estabelecimento"]: 1
        fornecedor          := params.Has("fornecedor")         ? params["fornecedor"]: 2
        cliente             := params.Has("cliente")            ? params["cliente"]: 100
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
