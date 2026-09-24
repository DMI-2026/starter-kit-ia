#!/usr/bin/env bash
# Prepara la práctica actual: OpenSpec para Antigravity, AGENTS.md del curso,
# config.yaml de OpenSpec y bitácora.
# Uso (desde la raíz de la práctica):
#   curl -fsSL https://raw.githubusercontent.com/DMI-2026/starter-kit-ia/main/setup.sh | bash
set -euo pipefail

BASE_URL="${STARTER_KIT_URL:-https://raw.githubusercontent.com/DMI-2026/starter-kit-ia/main}"

fail() { echo "✗ $1" >&2; exit 1; }
ok() { echo "✓ $1"; }

command -v git >/dev/null || fail "No encuentro git. Instálalo y vuelve a intentarlo."
command -v openspec >/dev/null || fail "No encuentro openspec. Sigue la guía: https://github.com/DMI-2026/starter-kit-ia/blob/main/openspec.md"
command -v curl >/dev/null || fail "No encuentro curl."

# 1. Repositorio git
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  git init -q
  ok "Repositorio git creado"
elif [ "$(git rev-parse --show-toplevel)" != "$(pwd -P)" ]; then
  fail "Ejecútalo desde la raíz del repositorio: $(git rev-parse --show-toplevel)"
fi

# 2. OpenSpec para Antigravity (skills y workflows en .agents/)
OPENSPEC_NO_ANIMATION=1 openspec init --tools antigravity --profile core </dev/null >/dev/null
ok "OpenSpec inicializado para Antigravity"

# 3. AGENTS.md del curso (siempre la versión oficial)
curl -fsSL "$BASE_URL/plantilla/AGENTS.md" -o AGENTS.md
ok "AGENTS.md descargado"

# 4. config.yaml: solo si todavía no es la plantilla del curso, para no borrar lo que ya completaste
if grep -q "Plantilla DMI 2026" openspec/config.yaml 2>/dev/null; then
  ok "openspec/config.yaml ya tiene la plantilla del curso (sin cambios)"
else
  curl -fsSL "$BASE_URL/plantilla/openspec-config.yaml" -o openspec/config.yaml
  ok "openspec/config.yaml descargado"
fi

# 5. Bitácora
if [ ! -f docs/bitacora-ia.md ]; then
  mkdir -p docs
  echo "# Bitácora de IA" > docs/bitacora-ia.md
  ok "docs/bitacora-ia.md creado"
fi

cat <<'EOF'

Listo. Te faltan dos cosas:
  1. Completa las líneas TODO(alumno) de openspec/config.yaml
  2. Guarda la configuración en git:
       git add AGENTS.md docs/ openspec/ .agents/
       git commit -m "chore: set up AGENTS.md and OpenSpec"
EOF
