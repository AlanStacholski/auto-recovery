$container = "chaos_target"

Write-Host " Iniciando Caos Inteligente..."

while ($true) {
    # 1. Pega o status atual (silenciando erros)
    $status = docker inspect --format '{{.State.Status}}' $container 2>$null

    # 2. Lógica de Decisão
    if ($status -eq "running") {
        Write-Host " [VIVO] O sistema está saudável. Preparando o tiro..."
        Start-Sleep -Seconds 5
        
        Write-Host " PUM! Matando container..."
        docker kill $container
    }
    elseif ($status -eq "exited") {
        Write-Host " [MORTO] Aguardando o Auto-Recovery do Docker..."
        # Espera curta para não floodar o terminal
        Start-Sleep -Seconds 2
    }
    elseif ($status -eq "restarting") {
        Write-Host " [REINICIANDO] O Docker está trabalhando..."
        Start-Sleep -Seconds 1
    }
    else {
        # Caso o container ainda não exista ou esteja em outro estado
        Write-Host " Status: $status - Aguardando..."
        Start-Sleep -Seconds 2
    }
}