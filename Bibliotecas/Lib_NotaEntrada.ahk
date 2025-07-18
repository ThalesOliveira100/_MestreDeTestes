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
InformarDadosGeraisDaNotaDeEntrada(params){
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

InformarValoresDaNotaDeEntrada(params){
    try {
        VlrTotalProdutos            := params.Has("VlrTotalProdutos")       ? params["VlrTotalProdutos"]: 5000
        VlrTotalServicos            := params.Has("VlrTotalServicos")       ? params["VlrTotalServicos"]: 0
        VlrFreteNotaFiscal          := params.Has("VlrFreteNotaFiscal")     ? params["VlrFreteNotaFiscal"]: 0
        VlrFreteConhecimento        := params.Has("VlrFreteConhecimento")   ? params["VlrFreteConhecimento"]: 0
        VlrSeguro                   := params.Has("VlrSeguro")              ? params["VlrSeguro"]: 0
        VlrICMSMonofasico           := params.Has("VlrICMSMonofasico")      ? params["VlrICMSMonofasico"]: 0
        VlrBaseCalculoICMS          := params.Has("VlrBaseCalculoICMS")     ? params["VlrBaseCalculoICMS"]: 0
        VlrICMS                     := params.Has("VlrICMS")                ? params["VlrICMS"]: 0
        VlrBaseCalculoICMSST        := params.Has("VlrBaseCalculoICMSST")   ? params["VlrBaseCalculoICMSST"]: 0
        VlrICMSST                   := params.Has("VlrICMSST")              ? params["VlrICMSST"]: 0
        VlrFCPST                    := params.Has("VlrFCPST")               ? params["VlrFCPST"]: 0
        VlrOutrasDespesas           := params.Has("VlrOutrasDespesas")      ? params["VlrOutrasDespesas"]: 0
        VlrIPI                      := params.Has("VlrIPI")                 ? params["VlrIPI"]: 0
        VlrDesconto                 := params.Has("VlrDesconto")            ? params["VlrDesconto"]: 0
        VlrICMSDesonerado           := params.Has("VlrICMSDesonerado")      ? params["VlrICMSDesonerado"]: 0

        tituloJanela                := "DYGNUS PREMIER"
        classVlrTotalProdutos       := "TJvDBCalcEdit17"
        classVlrTotalServicos       := "TJvDBCalcEdit16"
        classVlrFreteNotaFiscal     := "TJvDBCalcEdit15"
        classVlrFreteConhecimento   := "TJvDBCalcEdit9"
        classVlrSeguro              := "TJvDBCalcEdit14"
        classVlrICMSMonofasico      := "TJvDBCalcEdit1"
        classVlrBaseCalculoICMS     := "TJvDBCalcEdit21"
        classVlrICMS                := "TJvDBCalcEdit20"
        classVlrBaseCalculoICMSST   := "TJvDBCalcEdit19"
        classVlrICMSST              := "TJvDBCalcEdit18"
        classVlrFCPST               := "TJvDBCalcEdit3"
        classVlrOutrasDespesas      := "TJvDBCalcEdit13"
        classVlrIPI                 := "TJvDBCalcEdit12"
        classVlrDesconto            := "TJvDBCalcEdit11"
        classVlrICMSDesonerado      := "TJvDBCalcEdit2"

        InformarValorEmCampo(VlrTotalProdutos, classVlrTotalProdutos)
        InformarValorEmCampo(VlrTotalServicos, classVlrTotalServicos)
        InformarValorEmCampo(VlrFreteNotaFiscal, classVlrFreteNotaFiscal)
        InformarValorEmCampo(VlrFreteConhecimento, classVlrFreteConhecimento)
        InformarValorEmCampo(VlrSeguro, classVlrSeguro)
        InformarValorEmCampo(VlrICMSMonofasico, classVlrICMSMonofasico)
        InformarValorEmCampo(VlrBaseCalculoICMS, classVlrBaseCalculoICMS)
        InformarValorEmCampo(VlrICMS, classVlrICMS)
        InformarValorEmCampo(VlrBaseCalculoICMSST, classVlrBaseCalculoICMSST)
        InformarValorEmCampo(VlrICMSST, classVlrICMSST)
        InformarValorEmCampo(VlrFCPST, classVlrFCPST)
        InformarValorEmCampo(VlrOutrasDespesas, classVlrOutrasDespesas)
        InformarValorEmCampo(VlrIPI, classVlrIPI)
        InformarValorEmCampo(VlrDesconto, classVlrDesconto)
        InformarValorEmCampo(VlrICMSDesonerado, classVlrICMSDesonerado)

        SendInput("{Enter}{Enter}{Enter}")

    } catch as e {
        MsgBox("Erro na inclusão dos valores da nota de entrada: " . e.Message)
        return "FALHA"
    }
    return "SUCESSO"
}


InformarProdutosDaNotaDeEntrada(codigoProduto, cfop, params := Map()){
    try {
        tipoEntrada         := params.Has("tipoEntrada")        ? params["tipoEntrada"] : "REVENDA"
        localEntrada        := params.Has("localEntrada")       ? params["localEntrada"] : "VENDAS"
        unidade             := params.Has("unidade")            ? params["unidade"] : ""
        quantidade          := params.Has("quantidade")         ? params["quantidade"] : "1"
        vlrUnitario         := params.Has("vlrUnitario")        ? params["vlrUnitario"] : 25
        tipoDesconto        := params.Has("tipoDesconto")       ? params["tipoDesconto"] : ""
        vlrDesconto         := params.Has("VlrDesconto")        ? params["VlrDesconto"] : ""

        classTipoEntrada    := "TDBLookupComboBox3"
        classCFOP           := "TMaskEdit8"
        classLocalEntrada   := "TPanel17"
        classCodigoProduto  := "TMaskEdit7"
        classUnidade        := "TDBLookupComboBox1"
        classQuantidade     := "TJvCalcEdit7"
        classVlrUnitario    := "TJvCalcEdit6"
        classTipoDesconto   := "TMaskEdit4"
        classVlrDesconto    := "TJvCalcEdit5"

        InformarValorEmCampo(tipoEntrada, classTipoEntrada)
        InformarValorEmCampo(cfop, classCFOP)
        InformarValorEmCampo(localEntrada, classLocalEntrada)
        InformarValorEmCampo(codigoProduto, classCodigoProduto)
        InformarValorEmCampo(unidade, classUnidade)
        InformarValorEmCampo(quantidade, classQuantidade)
        InformarValorEmCampo(vlrUnitario, classVlrUnitario)
        InformarValorEmCampo(tipoDesconto, classTipoDesconto)
        InformarValorEmCampo(vlrDesconto, classVlrDesconto)
        SendInput("{Enter}")

        ; Informar Definição Fiscal do Item

        
    } catch as e {
        MsgBox("Erro na inclusão dos valores da nota de entrada: " . e.Message)
        return "FALHA"
    }
    return "SUCESSO"
}

InformarDefinicaoFiscalDoItem() {

}