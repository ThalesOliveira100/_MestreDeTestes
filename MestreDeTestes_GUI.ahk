#Requires AutoHotkey v2.0
#SingleInstance Force
SetTitleMatchMode(2)

; =================================================================================
; || MESTRE DE TESTES - PAINEL DE CONTROLE (GUI)                                  ||
; =================================================================================
; || Descrição: Interface gráfica para descobrir e executar todos os casos de     ||
; || teste da suíte de automação do sistema Dygnus.                               ||
; =================================================================================

; --- 1. DEFINIÇÃO DA INTERFACE GRÁFICA ---
MinhaGui := Gui(, "Suíte de Automação de Testes v0.0.1 - Dygnus Premier")
MinhaGui.MarginX := 15
MinhaGui.MarginY := 15
MinhaGui.SetFont("s10", "Segoe UI")
MinhaGui.Add("Text",, "Casos de teste encontrados:")

; ListView para exibir os testes de forma organizada.
LV := MinhaGui.Add("ListView", "r20 w800", ["Módulo", "Caso de Teste", "Status", "Caminho Completo"])
LV.ModifyCol(1, 150)
LV.ModifyCol(2, 300)
LV.ModifyCol(3, 100)
LV.ModifyCol(4, 0) ; Coluna 4 fica oculta, guardando o caminho do script

; Botões de ação
btnExecutar := MinhaGui.Add("Button", "w150 h30", "&Executar Selecionado")
btnExecutar.OnEvent("Click", ExecutarSelecionado.Bind(LV))

; btnExecutarTodos := MinhaGui.Add("Button", "x+10 w150 h30", "Executar &Todos")
; btnExecutarTodos.OnEvent("Click", ExecutarTodos.Bind(LV))

btnAtualizar := MinhaGui.Add("Button", "x+10 w150 h30", "&Atualizar Lista")
btnAtualizar.OnEvent("Click", PopularListaDeTestes.Bind(LV))


; --- 2. LÓGICA INICIAL ---
PopularListaDeTestes(LV)
MinhaGui.Show()

; Função para popular a lista de testes dinamicamente
PopularListaDeTestes(LV, *) {
    LV.Delete()

    caminhoDeBusca := A_ScriptDir . "\CasosDeTeste"

    Loop Files, caminhoDeBusca . "\*", "R" {
        if (A_LoopFileExt = "ahk") {
            SplitPath(A_LoopFileDir, , , , &dirPai)
            SplitPath(A_LoopFileFullPath, , , , &nomeDoTeste)
            LV.Add(, dirPai, nomeDoTeste, "Pronto", A_LoopFileFullPath)
        }
    }
}


; --- 3. FUNÇÕES DOS BOTÕES ---
; Executa o item que estiver selecionado na lista
ExecutarSelecionado(LV, *) {
    linhaSelecionada := LV.GetNext() ; Pega a primeira linha selecionada (ou 0 se não houver)
    if (linhaSelecionada = 0)
        Return

    ; Pega o caminho completo do script que está na coluna 4 (oculta)
    caminhoDoScript := LV.GetText(linhaSelecionada, 4)
    LV.Modify(linhaSelecionada, "Col3", "Executando...") ; Atualiza o Status na GUI
    
    ; Executa o script de teste como um processo separado e espera ele terminar.
    ; Esta é a forma mais robusta de executar os testes.
    exitCode := RunWait('"' A_AhkPath '" "' caminhoDoScript '"')

    ; Após o RunWait terminar, verifica o código de saída do processo
    if (exitCode = 0) {
        LV.Modify(linhaSelecionada, "Col3", "✅ Sucesso")
    } else {
        LV.Modify(linhaSelecionada, "Col3", "❌ Falhou")
    }
}

; Executa todos os testes da lista, um após o outro
; ExecutarTodos(LV, *) {
;     Loop LV.GetCount() {
;         LV.Modify(A_Index, "Select") ; Seleciona a linha atual
;         ExecutarSelecionado(LV) ; Chama a função para executar o item selecionado
;         Sleep(500) ; Uma pequena pausa entre os testes
;     }
; }

; Fecha o programa se a GUI for fechada
OnExit(Sair)
Sair(*) {
    ExitApp
}
