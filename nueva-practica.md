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
- Todo cambio de funcionalidad pasa por el flujo de OpenSpec:
  explore → propose → **cuestionario** → apply → archive.

### El cuestionario antes del apply

Después de `/opsx:propose`, el agente **no implementa nada** hasta que respondas
un cuestionario de **al menos 10 preguntas** sobre los artefactos del change
(`proposal.md`, `specs/`, `design.md` y `tasks.md`). Sirve para comprobar que
sabes lo que estás pidiendo y que leíste lo que se generó.

- Te hace **una pregunta a la vez**. Son preguntas abiertas, no de opción
  múltiple.
- Si te equivocas, te dice qué sección releer y te hace otra pregunta parecida.
  Puedes intentarlo las veces que necesites.
- Cuando respondes bien todas, **desbloquea el apply**.
- Todo queda registrado en `docs/bitacora-ia.md`: tus respuestas tal cual las
  escribiste y cuántos intentos te tomó cada una. Tu profesor revisa ese
  registro.

**Lee los artefactos antes de pedir el apply.** Es la forma más rápida de pasar
el cuestionario.

## Antes de empezar

Necesitas tener listos los pasos anteriores:
[Antigravity CLI](antigravity-cli.md) y [OpenSpec](openspec.md).

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

El script hace los pasos 1 a 5 de abajo: inicializa git si hace falta, configura
OpenSpec para Antigravity, descarga el `AGENTS.md` y el `config.yaml` del curso y
crea la bitácora. Si lo vuelves a ejecutar, actualiza el `AGENTS.md` pero **no
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

### 2. Inicializar OpenSpec

```bash
openspec init --tools antigravity
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

Debe responder que es tu **mentor**, que trabaja con OpenSpec y que no hace el
apply hasta que pases el cuestionario. Si responde como un asistente genérico, revisa que `AGENTS.md`
esté en la raíz y que abriste `agy` desde esa misma carpeta.

## Nombres de los comandos en Antigravity CLI

El `AGENTS.md` usa los nombres de OpenSpec (`/opsx:propose`). En `agy` se
escriben así:

| En `AGENTS.md` | En Antigravity CLI | En Antigravity 2.0 / IDE |
| --- | --- | --- |
| `/opsx:explore` | `/openspec-explore` | `/opsx-explore` |
| `/opsx:propose` | `/openspec-propose` | `/opsx-propose` |
| `/opsx:apply` | `/openspec-apply-change` | `/opsx-apply` |
| `/opsx:archive` | `/openspec-archive-change` | `/opsx-archive` |
