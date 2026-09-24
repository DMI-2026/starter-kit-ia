# Preparar cada práctica o repositorio

**Cada** práctica o repositorio en el que uses Antigravity y OpenSpec debe tener
el archivo [`AGENTS.md`](plantilla/AGENTS.md) del curso en su raíz. No es
opcional.

## Para qué sirve `AGENTS.md`

`AGENTS.md` es un archivo de instrucciones que el agente **lee solo, al empezar
a trabajar** en tu proyecto. Antigravity (la CLI y la app) lo busca en la raíz
del repositorio y lo sigue como reglas del proyecto.

El `AGENTS.md` del curso convierte al agente en un **mentor**:

- Responde corto, te pregunta una cosa a la vez y te explica el **porqué** de
  cada cambio.
- Si afirmas algo que no es correcto, no te da la razón: te explica por qué y
  te muestra la forma correcta.
- Las funcionalidades nuevas pasan por el flujo de OpenSpec:
  explore → propose → apply → verify → archive. Las correcciones y cambios
  puntuales los hace directo, sin ese flujo.
- Lleva una **bitácora** (`docs/bitacora-ia.md`): al cerrar cada tarea o cambio puntual anota qué
  conceptos viste, qué escribiste tú, qué escribió el agente y qué dudas
  quedaron. Tu profesor la revisa como parte de la entrega.

## Antes de empezar

Necesitas tener listos los pasos anteriores:

- [Antigravity CLI](antigravity-cli.md) instalado.
- [OpenSpec](openspec.md) instalado.
- [Git y GitHub CLI](github-cli.md) configurados, sobre todo tu nombre y correo
  en git (paso 3 de esa guía). Sin eso, el commit del final falla con
  *"Please tell me who you are"*.
- Tu proyecto Flutter ya creado (por ejemplo, con `flutter create mi_practica`).
  Todos los pasos se hacen **dentro** de esa carpeta.

## Opción rápida: un solo comando

Desde la **raíz** del repositorio de la práctica, ejecuta:

**macOS / Linux:**

```bash
curl -fsSL https://raw.githubusercontent.com/DMI-2026/starter-kit-ia/main/setup.sh | bash
```

**Windows (PowerShell):**

```powershell
irm https://raw.githubusercontent.com/DMI-2026/starter-kit-ia/main/setup.ps1 | iex
```

El script hace los pasos 1 a 5 de abajo: inicializa git si hace falta, activa
`/opsx:verify` en OpenSpec (sin quitar otros flujos que ya tengas), configura
OpenSpec para Antigravity, instala con [autoskills](https://www.autoskills.sh/)
las skills que corresponden a tu stack (requiere Node.js; si no lo tienes, lo
omite y te avisa), descarga el `AGENTS.md` y el `config.yaml` del curso y crea la
bitácora. Si lo vuelves a ejecutar, actualiza el `AGENTS.md` pero **no
borra** lo que ya completaste en tu `config.yaml`.

Como siempre, [léelo antes de ejecutarlo](setup.sh). Al terminar, te faltan
**dos cosas**: completar los `TODO(alumno)` de `openspec/config.yaml` (paso 4) y
hacer el commit (paso 6).

## Pasos para cada práctica nueva (manual)

Si prefieres hacerlo a mano o el script falla, hazlos en la **raíz** del
repositorio de la práctica.

### 1. Entrar al repositorio

```bash
cd mi-practica
git status
```

Si dice `not a git repository`, primero ejecuta `git init`.

### 2. Inicializar OpenSpec con `verify`

El flujo del curso usa `/opsx:verify`, que no viene en el perfil por defecto de
OpenSpec. Actívalo (una sola vez por computadora) con `openspec config profile`:
elige **Change workflows only**, marca **`verify`** y confirma. Después:

```bash
openspec init --tools antigravity --profile custom
```

### 3. Descargar el `AGENTS.md` del curso

**macOS / Linux:**

```bash
curl -fsSL https://raw.githubusercontent.com/DMI-2026/starter-kit-ia/main/plantilla/AGENTS.md -o AGENTS.md
```

**Windows (PowerShell):**

```powershell
Invoke-WebRequest https://raw.githubusercontent.com/DMI-2026/starter-kit-ia/main/plantilla/AGENTS.md -OutFile AGENTS.md
```

> **No lo modifiques.** Es el mismo archivo para todo el grupo. Si crees que algo
> debería cambiar, coméntalo con tu profesor.

### 4. Reemplazar la configuración de OpenSpec

La plantilla del curso le dice al agente qué stack usas (Flutter, MVVM), en qué
idioma escribir y qué debe tener cada propuesta, spec, diseño y lista de tareas.

**macOS / Linux:**

```bash
curl -fsSL https://raw.githubusercontent.com/DMI-2026/starter-kit-ia/main/plantilla/openspec-config.yaml -o openspec/config.yaml
```

**Windows (PowerShell):**

```powershell
Invoke-WebRequest https://raw.githubusercontent.com/DMI-2026/starter-kit-ia/main/plantilla/openspec-config.yaml -OutFile openspec/config.yaml
```

Abre `openspec/config.yaml` y **completa las dos líneas `TODO(alumno)`**: el
nombre del proyecto, qué problema resuelve y quién lo usa. A diferencia de
`AGENTS.md`, este archivo **sí es tuyo**: si tu práctica usa algo distinto
(otra plataforma, una base de datos), agrégalo al `context`.

### 5. Crear la bitácora

El agente escribe en `docs/bitacora-ia.md`. Créala vacía con un título:

**macOS / Linux:**

```bash
mkdir -p docs && echo "# Bitácora de IA" > docs/bitacora-ia.md
```

**Windows (PowerShell):**

```powershell
New-Item -ItemType Directory -Force docs | Out-Null; Set-Content docs/bitacora-ia.md "# Bitácora de IA"
```

### 6. Guardar en git

Opcional, antes del commit: instala las skills de tu stack con
`npx autoskills -a universal` (quedan en `.agents/skills/` y crea `skills-lock.json`;
si lo usaste, agrega `skills-lock.json` al `git add`).

```bash
git add AGENTS.md docs/ openspec/ .agents/
git commit -m "chore: set up AGENTS.md and OpenSpec"
```

Estos archivos **sí se suben** al repositorio. El profesor revisa la bitácora y
las specs como parte de la entrega.

---

## Comprobación

Tu repositorio debe verse así:

```text
mi-practica/
├── AGENTS.md
├── docs/
│   └── bitacora-ia.md
├── openspec/
│   ├── specs/
│   ├── changes/
│   └── config.yaml
└── .agents/
```

Luego abre `agy` en la raíz y pregúntale:

```text
¿Qué reglas sigues en este proyecto?
```

Debe responder que es tu **mentor**, que trabaja con OpenSpec y que lleva una
bitácora de aprendizaje. Si responde como un asistente genérico, revisa que `AGENTS.md`
esté en la raíz y que abriste `agy` desde esa misma carpeta.

## Nombres de los comandos en Antigravity CLI

El `AGENTS.md` usa los nombres de OpenSpec (`/opsx:propose`). En `agy` se
escriben así:

| En `AGENTS.md` | En Antigravity CLI | En Antigravity 2.0 / IDE |
| --- | --- | --- |
| `/opsx:explore` | `/openspec-explore` | `/opsx-explore` |
| `/opsx:propose` | `/openspec-propose` | `/opsx-propose` |
| `/opsx:apply` | `/openspec-apply-change` | `/opsx-apply` |
| `/opsx:verify` | `/openspec-verify-change` | `/opsx-verify` |
| `/opsx:archive` | `/openspec-archive-change` | `/opsx-archive` |

## Problemas comunes

**`Esta carpeta no es la raíz de su propio repositorio git`**
Tu práctica todavía no es un repositorio git (`flutter create` no lo crea) y
alguna carpeta superior sí lo es. Si esa carpeta superior es tu carpeta personal
(`/Users/<tu-usuario>` o `C:\Users\<tu-usuario>`), casi seguro fue un `git init`
por error. Para tu práctica basta con ejecutar `git init` dentro de ella y
volver a correr el comando.
