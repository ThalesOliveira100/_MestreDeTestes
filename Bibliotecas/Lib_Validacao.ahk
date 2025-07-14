#Requires AutoHotkey v2.0
SetTitleMatchMode(1) ; Define que a busca pelo título do programa deve começar com o indicado.

; =================================================================================
; || BIBLIOTECA DE FUNÇÕES DO SISTEMA                                             ||
; =================================================================================
; || Descrição: Contém as funções básicas para validação de mensagens do sistema, ||
; || tais como falta de estoque e outras do assistente do sistema.                 ||
; =================================================================================

ValidarExibicaoMensagemAssistenteSistema(){
    try {
        classJanelaAssistenteSistema := "Tfrm_AgenteErro"

        if WinExist("ahk_class " . classJanelaAssistenteSistema, , 3) {
            try {
                ControlClick("TBitBtn1")

            } catch as e {
                MsgBox("Erro ao validar fechar mensagem do Assistente do Sistema: " e.Message)
            }
        }
    } catch {
        
    }
}

ValidarExibicaoPosicaoFinanceiraCliente(){
    try {
        Sleep(1500)
        classeJanelaPosicaoFinanceiraCliente := "Tfrm_ExibeDebitosCliente"

        if WinExist("ahk_class " . classeJanelaPosicaoFinanceiraCliente, , 3) {
            ; MsgBox("Achei a posicao financeira do cliente")
            try {
                ControlClick("TBitBtn2")

            } catch as e {
                MsgBox("Erro ao validar posicao financeira do cliente " . e.Message)
            }
        }        
    } catch {

    }
}

