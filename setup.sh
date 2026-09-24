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
  top="$(git rev-parse --show-toplevel)"
  fail "Esta carpeta no es la raíz de su propio repositorio git: git está usando el de $top
  - Si esta carpeta ES tu práctica, conviértela en repositorio con:  git init
    y vuelve a ejecutar el comando.
  - Si solo estás en una subcarpeta de tu práctica, entra a:  $top"
fi

# 2. Activar /opsx:verify en OpenSpec (configuración global, sin borrar flujos que ya tengas)
# Supone que `openspec config get workflows` imprime un arreglo JSON en una línea,
# como ["propose","apply"]; así lo hace OpenSpec 1.13.
core='["propose","explore","apply","update","sync","archive"]'
profile="$(openspec config get profile 2>/dev/null || true)"
workflows="$(openspec config get workflows 2>/dev/null || true)"
if [ "$profile" = custom ] && case "$workflows" in *'"verify"'*) true ;; *) false ;; esac; then
  ok "Flujo verify ya estaba activo en OpenSpec (sin cambios)"
else
  if [ "$profile" != custom ] || [ -z "$workflows" ] || [ "$workflows" = "[]" ]; then
    workflows="$core"
  fi
  case "$workflows" in
    *'"verify"'*) ;;
    *) workflows="${workflows%]},\"verify\"]" ;;
  esac
  openspec config set profile custom >/dev/null
  openspec config set workflows "$workflows" >/dev/null
  ok "Flujo verify activado en OpenSpec"
fi

# 3. OpenSpec para Antigravity (skills y workflows en .agents/)
OPENSPEC_NO_ANIMATION=1 openspec init --tools antigravity --profile custom </dev/null >/dev/null
ok "OpenSpec inicializado para Antigravity"

# 4. AGENTS.md del curso (siempre la versión oficial)
curl -fsSL "$BASE_URL/plantilla/AGENTS.md" -o AGENTS.md
ok "AGENTS.md descargado"

# 5. config.yaml: solo si todavía no es la plantilla del curso, para no borrar lo que ya completaste
if grep -q "Plantilla DMI 2026" openspec/config.yaml 2>/dev/null; then
  ok "openspec/config.yaml ya tiene la plantilla del curso (sin cambios)"
else
  curl -fsSL "$BASE_URL/plantilla/openspec-config.yaml" -o openspec/config.yaml
  ok "openspec/config.yaml descargado"
fi

# 6. Bitácora
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
