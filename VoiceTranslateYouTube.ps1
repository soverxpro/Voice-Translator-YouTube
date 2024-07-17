

# Настройка кодировки на UTF-8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Функция для отображения информации о системе
function Show-SystemInfo {
    Write-Host "System Information:"
    Write-Host "OS: $(Get-WmiObject -Class Win32_OperatingSystem | Select-Object -ExpandProperty Caption)"
    Write-Host "Architecture: $([System.Environment]::Is64BitOperatingSystem)"
    Write-Host "Username: $(whoami)"
}

# Клонирование репозитория и переход в директорию
$repoUrl = "https://github.com/soverxpro/voice-over-translation.git"
$repoDir = "voice-over-translation"

if (-not (Test-Path $repoDir)) {
    git clone $repoUrl
}

Set-Location $repoDir

# Выполнение команд npm
Write-Host "Installing dependencies using npm..."
npm install

if ($?) {
    Write-Host "Fixing vulnerabilities..."
    npm audit fix
} else {
    Write-Host "Error installing dependencies." -ForegroundColor Red
    exit 1
}

if ($?) {
    Write-Host "Building the project..."
    npm run build
} else {
    Write-Host "Error building the project." -ForegroundColor Red
    exit 1
}

if ($?) {
    Write-Host "Preparing the project..."
    npm run prepare
} else {
    Write-Host "Error preparing the project." -ForegroundColor Red
    exit 1
}

Write-Host "Project prepared successfully!" -ForegroundColor Green

# Выход из папки проекта
Write-Host "Exiting project directory..."
cd..

# Проверка существования папки проекта перед удалением
if (Test-Path $repoDir) {
    # Удаление папки проекта
    Write-Host "Deleting project directory..."
    Remove-Item $repoDir -Recurse -Force
    Write-Host "Project directory has been deleted successfully!" -ForegroundColor Green
} else {
    Write-Host "The project directory does not exist. Skipping deletion." -ForegroundColor Yellow
}

#Write-Host "Project directory has been deleted successfully!" -ForegroundColor Green

# Сообщение о завершении работы
Write-Host "All operations completed successfully!" -ForegroundColor Green

# Ссылки на установку расширений
Write-Host "`nPlease install the following extensions:" -ForegroundColor Yellow
Write-Host "Tampermonkey: https://www.tampermonkey.net/"
Write-Host "UserScripts (for Safari): https://userscripts.org/"
Write-Host "Cloudflare Script: https://raw.githubusercontent.com/ilyhalight/voice-over-translation/master/dist/vot-cloudflare.user.js"
Write-Host "UserScript: https://raw.githubusercontent.com/ilyhalight/voice-over-translation/master/dist/vot.user.js"

Read-Host "Press Enter to close this window..."
