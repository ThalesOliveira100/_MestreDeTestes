#Requires AutoHotkey v2.0
SetTitleMatchMode(1) ; Define que a busca pelo título do programa deve começar com o indicado.

; =================================================================================
; || BIBLIOTECA DE FUNÇÕES DO SISTEMA                                             ||
; =================================================================================
; || Descrição: Contém as funções básicas para interação com o sistema, tais como ||
; || abrir, logar e fechar. Também lê as configurações do arquivo Config.ini.     ||
; =================================================================================


/**
 * Inicia o executável do sistema.
 * Lê o caminho do executável a partir do arquivo Config.ini.
 * @return {String} "SUCESSO" ou "FALHA".
 */
LaunchApp() {
    caminhoConfig := A_InitialWorkingDir . "/Config.ini"
    caminhoApp := IniRead(caminhoConfig, "SISTEMA", "CaminhoExecutavel")
    classeJanelaLogin := "ahk_class Tfrm_LoginSistema"

    if not caminhoApp {
        MsgBox("A chave 'CaminhoExecutavel' não foi encontrada no Config.ini.", "Erro de Configuração", 16)
        Return "FALHA"
    }

    if not FileExist(caminhoApp) {
        MsgBox("O caminho do executável especificado no Config.ini não foi encontrado:`n" . caminhoApp, "Erro de Configuração", 16)
        Return "FALHA"
    }

    try {
        Run(caminhoApp)
        WinWait(classeJanelaLogin, , 3)

    } catch as e {
        MsgBox("Falha ao tentar executar o aplicativo:`n" . e.Message, "Erro de Execução", 16)
        Return "FALHA"
    }
    
    Return "SUCESSO"
}


/**
 * Essa função verificará a exibição do aviso de feriados, e clicará no botão para fechá-lo.
 * @return {String} "SUCESSO" ou "FALHA"
 */
VerificaPopUpDeAvisoFeriados() {
    classeDoPopUp := "ahk_class #32770"
    hWnd := WinWait(classeDoPopUp, ,3)

    try {
         if (hWnd) {
            WinActivate("ahk_id " . hWnd)
            Send("{Enter}")
            WinWaitClose("ahk_id " . hWnd, , 2)
         }
    } catch as e {
        MsgBox("Erro encontrado: " . e.Message)
    }

    Return "SUCESSO"
}


/**
 * Realiza o processo de login no sistema.
 * Lê as credenciais e informações da janela a partir do Config.ini.
 * @return {String} "SUCESSO" ou "FALHA".
 */
Login() {
    caminhoConfig := A_InitialWorkingDir . "/Config.ini"
    TituloJanela := IniRead(caminhoConfig, "SISTEMA", "TituloJanela")
    user := IniRead(caminhoConfig, "CREDENCIAIS", "Usuario", "MULT")
    pass := IniRead(caminhoConfig, "CREDENCIAIS", "Senha", "COBOL")
    
    If not TituloJanela {
        MsgBox("A chave 'TituloJanela' não foi encontrada no Config.ini.", "Erro de Configuração", 16)
        Return "FALHA"
    }
    
    campoUsuarioClassNN := "Edit1"
    campoSenhaClassNN := "TEdit1"
    botaoEntrarClassNN := "TBitBtn4"

    try {
        if not WinWait(TituloJanela, , 10) {
            MsgBox("Tempo de espera excedido. A janela de login '" . TituloJanela . "' não foi encontrada.", "Erro de Login", 16)
            Return "FALHA"
        }
        
        WinActivate(TituloJanela)
        ControlSetText(user, campoUsuarioClassNN, TituloJanela)
        ControlSetText(pass, campoSenhaClassNN, TituloJanela)
        ControlClick(botaoEntrarClassNN, TituloJanela)
        
        VerificaPopUpDeAvisoFeriados()

        ; if not WinWait(TituloJanela, "Menu Principal", 10) {
        ;     MsgBox("Erro: A tela principal não foi carregada", "Erro de login", 16)
        ;     return "FALHA"
        ; }

    } catch as e {
        MsgBox("Ocorreu uma exceção durante o login:`n" . e.Message, "Erro de Login", 16)
        Return "FALHA"
    }

    Return "SUCESSO"
}


/**
 * Acessa uma tela específica do sistema via atalho de busca, utilizando o código informado.
 * Simula o pressionamento de ALT + F, espera pela janela de busca, preenche o código e confirma.
 * @param {String} codigo - O código da tela a ser inserido.
 * @return {String} "SUCESSO" ou "FALHA"
 */
AcessarTelaPorCodigo(codigo) {
    try {
        SendInput("!f")
        classeDaJanelaPesquisa := "Tfrm_Pesquisa_Opcoes_Sistema"

        hWnd := WinWait("ahk_class " . classeDaJanelaPesquisa, , 3)

        if not hWnd {
            MsgBox("Não foi possível acionar a janela de consulta", "Erro", 16)
            return "FALHA"
        }

        WinActivate("ahk_id " . Hwnd)
        SendInput(codigo)
        SendInput("{Enter}")
        WinWaitClose("ahk_id " . hWnd, , 3)

        return "SUCESSO"

    } catch as e {
        MsgBox("Erro encontrado: " . e.Message)
        return "FALHA"
    }
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


InformarValorEmCampo(valor, classCampo, janela := "DYGNUS PREMIER") {
    ControlFocus(classCampo, janela)
    SendInput("^a")
    SendInput(valor)
    Sleep(500)
}


/**
 * Fecha a janela principal do sistema.
 * @return {String} "SUCESSO"
 */
FecharSistema() {
    caminhoConfig := A_InitialWorkingDir . "/Config.ini"
    TituloJanela := IniRead(caminhoConfig, "SISTEMA", "TituloJanela")
    try {
        WinClose(TituloJanela)

        hWnd := WinWait("Confirmação")
        if (hWnd) {
            WinActivate("ahk_id " . hWnd)
            WinWait("ahk_id " . hWnd)
            ControlClick("Button1", "Confirmação")
            WinWaitClose("ahk_id " . hWnd, , 2)
        }
    }
    Return "SUCESSO"
}

