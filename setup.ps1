# Prepara la práctica actual: OpenSpec para Antigravity, AGENTS.md del curso,
# config.yaml de OpenSpec y bitácora.
# Uso (desde la raíz de la práctica, en PowerShell):
#   irm https://raw.githubusercontent.com/DMI-2026/starter-kit-ia/main/setup.ps1 | iex

& {
  # Sin 'Stop' global: en Windows PowerShell 5.1 convertiría en error cualquier
  # texto que git u openspec escriban en stderr (spinners, avisos).
  $BaseUrl = if ($env:STARTER_KIT_URL) { $env:STARTER_KIT_URL } else { 'https://raw.githubusercontent.com/DMI-2026/starter-kit-ia/main' }

  function Ok($msg) { Write-Host "✓ $msg" -ForegroundColor Green }

  foreach ($cmd in 'git', 'openspec') {
    if (-not (Get-Command $cmd -ErrorAction SilentlyContinue)) {
      throw "No encuentro $cmd. Revisa la guía: https://github.com/DMI-2026/starter-kit-ia"
    }
  }

  # 1. Repositorio git
  $root = git rev-parse --show-toplevel 2>$null
  if ($LASTEXITCODE -ne 0) {
    git init -q
    Ok 'Repositorio git creado'
  } elseif ((Resolve-Path $root).Path -ne (Get-Location).Path) {
    throw "Esta carpeta no es la raíz de su propio repositorio git: git está usando el de $root`n  - Si esta carpeta ES tu práctica, conviértela en repositorio con:  git init`n    y vuelve a ejecutar el comando.`n  - Si solo estás en una subcarpeta de tu práctica, entra a:  $root"
  }

  # 2. OpenSpec para Antigravity (skills y workflows en .agents/)
  $env:OPENSPEC_NO_ANIMATION = '1'
  openspec init --tools antigravity --profile core | Out-Null
  if ($LASTEXITCODE -ne 0) { throw 'openspec init falló. Ejecútalo a mano para ver el error.' }
  Ok 'OpenSpec inicializado para Antigravity'

  # 3. AGENTS.md del curso (siempre la versión oficial)
  Invoke-WebRequest "$BaseUrl/plantilla/AGENTS.md" -OutFile AGENTS.md -UseBasicParsing -ErrorAction Stop
  Ok 'AGENTS.md descargado'

  # 4. config.yaml: solo si todavía no es la plantilla del curso, para no borrar lo que ya completaste
  $config = 'openspec/config.yaml'
  if ((Test-Path $config) -and (Select-String -Path $config -Pattern 'Plantilla DMI 2026' -Quiet)) {
    Ok "$config ya tiene la plantilla del curso (sin cambios)"
  } else {
    Invoke-WebRequest "$BaseUrl/plantilla/openspec-config.yaml" -OutFile $config -UseBasicParsing -ErrorAction Stop
    Ok "$config descargado"
  }

  # 5. Bitácora
  if (-not (Test-Path docs/bitacora-ia.md)) {
    New-Item -ItemType Directory -Force docs | Out-Null
    Set-Content docs/bitacora-ia.md '# Bitácora de IA' -Encoding utf8
    Ok 'docs/bitacora-ia.md creado'
  }

  Write-Host ''
  Write-Host 'Listo. Te faltan dos cosas:'
  Write-Host '  1. Completa las líneas TODO(alumno) de openspec/config.yaml'
  Write-Host '  2. Guarda la configuración en git:'
  Write-Host '       git add AGENTS.md docs/ openspec/ .agents/'
  Write-Host '       git commit -m "chore: set up AGENTS.md and OpenSpec"'
}
