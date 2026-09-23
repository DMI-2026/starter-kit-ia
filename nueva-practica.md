# Preparar cada práctica o repositorio

**Cada** práctica o repositorio en el que uses Antigravity y OpenSpec debe tener
el archivo [`AGENTS.md`](plantilla/AGENTS.md) del curso en su raíz. No es
opcional.

## Para qué sirve `AGENTS.md`

`AGENTS.md` es un archivo de instrucciones que el agente **lee solo, al empezar
a trabajar** en tu proyecto. Antigravity (la CLI y la app) lo busca en la raíz
del repositorio y lo sigue como reglas del proyecto.

El `AGENTS.md` del curso convierte al agente en un **tutor**:

- Te ayuda a construir el proyecto, pero **la lógica central la escribes tú**.
- Todo cambio pasa primero por una spec de OpenSpec.
- Cuando algo falla, te da pistas por niveles en lugar de arreglarlo de golpe.
- Lleva una **bitácora** de lo que aprendiste y de lo que escribió cada quien.

Si le pides "hazlo todo", te va a decir que no y va a dividir el trabajo. Así
está diseñado: lo que entregas lo tienes que poder explicar tú.

## Antes de empezar

Necesitas tener listos los pasos anteriores:
[Antigravity CLI](antigravity-cli.md) y [OpenSpec](openspec.md).

## Paso 0: activar `verify` en OpenSpec (una sola vez por computadora)

El `AGENTS.md` usa `/opsx:verify`, que **no viene en el perfil por defecto** de
OpenSpec. Actívalo una vez:

```bash
openspec config profile
```

Elige **Change workflows only**, marca **`verify`** en la lista (deja marcados
los que ya estaban) y confirma. Esto se guarda en tu computadora y aplica a
todos tus proyectos a partir de aquí.

---

## Pasos para cada práctica nueva

Hazlos en la **raíz** del repositorio de la práctica.

### 1. Entrar al repositorio

```bash
cd mi-practica
git status
```

Si dice `not a git repository`, primero ejecuta `git init`.

### 2. Inicializar OpenSpec

```bash
openspec init --tools antigravity,agents --profile custom
```

`--profile custom` usa los flujos que elegiste en el paso 0, incluido `verify`.

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
git add AGENTS.md docs/ openspec/ .agent/ .agents/
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
├── .agent/
└── .agents/skills/
```

Luego abre `agy` en la raíz y pregúntale:

```text
¿Qué reglas sigues en este proyecto?
```

Debe responder que es un **tutor**, que trabaja con OpenSpec y que tú escribes la
lógica central. Si responde como un asistente genérico, revisa que `AGENTS.md`
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
