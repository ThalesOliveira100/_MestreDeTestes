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
        classJanelaNotaEntrada := "Tfrm_NotaFiscalEntrada1"
        WinWaitActive('ahk_class ' . classJanelaNotaEntrada, , 3)

        estabelecimento     := params.Has("estabelecimento")    ? params["estabelecimento"]: 1
        fornecedor          := params.Has("fornecedor")         ? params["fornecedor"]: 2
        cliente             := params.Has("cliente")            ? params["cliente"]: 100
        tipoDocumento       := params.Has("tipoDocumento")      ? params["tipoDocumento"]: 2
        numero              := params.Has("numero")             ? params["numero"]: ""
        serie               := params.Has("serie")              ? params["serie"]: ""
        tipoCadastro        := params.Has("tipoCadastro")       ? params["tipoCadastro"]: "F"

        classCampoEstabelecimento := "TMaskEdit15"
        classCampoCadastro := "TMaskEdit14"
        classCampoTipoDocumento := "TMaskEdit13"
        classCampoNumero := "TMaskEdit12"
        classCampoSerie := "TJvDBLookupCombo1"
        classCampoTipoCadastro := "TEdit1"

        ; Informa o estabelecimento
        InformarValorEmCampo(estabelecimento, classCampoEstabelecimento, "DYGNUS PREMIER")
        SendInput("{Enter}")

        ; Confere se o tipoCadastro não é F, e exibe mensagem informando que ainda não está preparado, retorna ao fluxo
        if (tipoCadastro != "F") {
            MsgBox("Tipo de cadastro diferente de F informado, script ainda não está preparado para isso")
            WinActivate("DYGNUS PREMIER")
        }

        ; Informa código do fornecedor
        InformarValorEmCampo(fornecedor, classCampoCadastro)
        SendInput("{Enter}")

        ; Informa código do tipo de documento
        InformarValorEmCampo(tipoDocumento, classCampoTipoDocumento)
        SendInput("{Enter}")

        ; Gera um número aleatório de 1000 a 99999 caso o número não seja especificado.
        if (numero == "") {
            numero := Random(1000, 99999)
        }

        ; Informa o número da nota
        InformarValorEmCampo(numero, classCampoNumero)
        SendInput("{Enter}")

        ; Se a série não estiver em branca, para utilizar o valor padrão, irá informar o número da série.
        if (serie != "") {
            InformarValorEmCampo(serie, classCampoSerie)
            SendInput("{Enter}")
        }

        SendInput("{Enter}{F3}")

        ; Se o tipo de documento da nota for 15, exigindo informação da chave de acesso, o sistema executa a função para tentar encontrar a chave.
        if (tipoDocumento == 15) {
            WinWait("Confirm", , 3)
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

        Loop 3 {
            SendInput("{Enter}")
        }

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

        Sleep(500)

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

        InformarDefinicaoFiscalDoItem()

        
    } catch as e {
        MsgBox("Erro na inclusão dos valores da nota de entrada: " . e.Message)
        return "FALHA"
    }
    return "SUCESSO"
}

InformarDefinicaoFiscalDoItem(CSTIPI := 49, CSTICMS := 90, CSTPISCOFINS := 98, params := Map()) {
    try {
        valorAliquotaICMS       := params.Has("aliquotaICMS")       ? params["aliquotaICMS"] : ""
        valorPercentualReducao  := params.Has("percentualReducao")  ? params["percentualReducao"] : ""
        valorBCICMS             := params.Has("BCICMS")             ? params["BCICMS"] : 0
        valorICMS               := params.Has("ICMS")               ? params["ICMS"] : 0
        valorIsentoICMS         := params.Has("isentoICMS")         ? params["isentoICMS"] : 0
        valorOutrasICMS         := params.Has("outrasICMS")         ? params["outrasICMS"] : 0
        percentualMVAST         := params.Has("percentualMVAST")    ? params["percentualMVAST"] : 0
        naturezaFrete           := params.Has("naturezaFrete")      ? params["naturezaFrete"] : 9
        

        tituloJanela := "Definição Contábil / Fiscal do Item"
        WinWaitActive(tituloJanela, , 3)

        classCampoCSTIPI := "TDBEdit4"
        classCampoCSTICMS := "TDBEdit7"
        classCampoCSTPISCOFINS := "TDBEdit1"
        classCampoAliquotaICMS := "TJvDBCalcEdit36"
        classPercentualReducao := "TJvDBCalcEdit31"
        classCampoValorBCICMS := "TJvDBCalcEdit40"
        classCampoValorICMS := "TJvDBCalcEdit39"
        classCampoValorIsentoICMS := "TJvDBCalcEdit38"
        classCampoValorOutrasICMS := "TJvDBCalcEdit37"
        classCampoPercentualMVAST := "TJvDBCalcEdit32"
        classCampoNaturezaFrete := "TDBEdit2"
        classBotaoConfirmar := "TBitBtn3"

        Sleep(500)

        InformarValorEmCampo(CSTIPI, classCampoCSTIPI, tituloJanela)
        InformarValorEmCampo(CSTICMS, classCampoCSTICMS, tituloJanela)

        if not (valorAliquotaICMS == "") {
            InformarValorEmCampo(valorAliquotaICMS, classCampoAliquotaICMS, tituloJanela)
        }

        if not (valorPercentualReducao == "") {
            InformarValorEmCampo(valorPercentualReducao, classPercentualReducao, tituloJanela)
        }

        InformarValorEmCampo(valorBCICMS, classCampoValorBCICMS, tituloJanela)
        InformarValorEmCampo(valorICMS, classCampoValorICMS, tituloJanela)
        InformarValorEmCampo(valorIsentoICMS, classCampoValorIsentoICMS, tituloJanela)
        InformarValorEmCampo(valorOutrasICMS, classCampoValorOutrasICMS, tituloJanela)
        InformarValorEmCampo(percentualMVAST, classCampoPercentualMVAST, tituloJanela)
        InformarValorEmCampo(CSTPISCOFINS, classCampoCSTPISCOFINS, tituloJanela)
        InformarValorEmCampo(naturezaFrete, classCampoNaturezaFrete, tituloJanela)

        Sleep(500)

        ControlClick(classBotaoConfirmar, tituloJanela)

        WinWaitClose(tituloJanela, , 3)

    } catch as e {
        MsgBox("Erro na inclusão da Definição Fiscal do Item: " . e.Message)
        return "FALHA"
    }
    return "SUCESSO"
}