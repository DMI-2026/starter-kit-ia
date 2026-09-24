# Instalar OpenSpec y configurarlo para Antigravity

Fuentes oficiales: [openspec.dev](https://openspec.dev/) ·
[repositorio](https://github.com/Fission-AI/OpenSpec) ·
[herramientas compatibles](https://github.com/Fission-AI/OpenSpec/blob/main/docs/supported-tools.md)

## Para qué sirve

Cuando le pides algo a un agente de IA en el chat ("agrega login a la app"), lo
que querías hacer vive **solo en la conversación**. Si la sesión se cierra, se
pierde. Si el agente entendió otra cosa, te das cuenta hasta que ya escribió el
código.

**OpenSpec** resuelve eso con una regla sencilla: **primero se acuerda qué se va
a construir y después se escribe código.** Cada cambio tiene su propia carpeta
con cuatro documentos Markdown:

| Archivo | Qué contiene |
| --- | --- |
| `proposal.md` | Por qué se hace el cambio y qué abarca |
| `specs/` | Requisitos con escenarios concretos ("dado… cuando… entonces…") |
| `design.md` | Cómo se va a implementar |
| `tasks.md` | Lista de tareas para marcar conforme avanzas |

Tú **revisas y corriges esos documentos antes** de que el agente toque el código.
Es lo mismo que se hace en los equipos de la industria con un documento de
diseño o un ticket bien escrito: nadie construye sin haber acordado los planos.

El ciclo tiene cuatro comandos que usas **dentro del agente**:

```text
/opsx:explore   → pensar el problema con el agente, sin escribir código
/opsx:propose   → crear proposal, specs, design y tasks
/opsx:apply     → implementar las tareas
/opsx:archive   → cerrar el cambio y actualizar las specs del proyecto
```

## Antes de empezar

| | |
| --- | --- |
| **Requisito** | **Node.js 20.19.0 o superior** |
| **Agente** | Antigravity CLI ya instalado ([paso 1](antigravity-cli.md)) |
| **Proyecto** | Una carpeta de proyecto, idealmente ya con `git init` |
| **Tiempo** | 10 minutos |

**Comprobación de Node.js:**

```bash
node --version
```

Debe imprimir `v20.19.0` o un número mayor (por ejemplo `v22.x`). Si dice
`command not found` o una versión menor, instala la versión **LTS** desde
<https://nodejs.org> y abre una terminal nueva.

---

## Instalar OpenSpec

El comando es el mismo en **macOS, Linux y Windows** (PowerShell o CMD):

```bash
npm install -g @fission-ai/openspec@latest
```

En macOS o Linux con Homebrew también puedes usar `brew install openspec`.

> **Linux / macOS: `EACCES: permission denied`**
> **No** uses `sudo npm install -g`. Significa que Node.js se instaló en una
> carpeta del sistema. Lo correcto es instalar Node.js con un gestor de
> versiones como [nvm](https://github.com/nvm-sh/nvm) o con Homebrew, y repetir
> la instalación.

**Comprobación:**

```bash
openspec --version
```

Debe imprimir un número de versión.

---

## Inicializar el proyecto para Antigravity

Entra a la carpeta de tu proyecto y ejecuta **un solo comando**:

```bash
cd mi-proyecto
openspec init --tools antigravity
```

La opción `--tools` configura Antigravity sin preguntas interactivas. Crea la
carpeta **`.agents/`**, que leen tanto la CLI (`agy`) como la app y el IDE:

| Carpeta | Qué contiene | Cómo se usa |
| --- | --- | --- |
| `.agents/skills/` | Skills de OpenSpec | En la CLI: `/openspec-propose`, etc. |
| `.agents/workflows/` | Workflows de OpenSpec | En la app / IDE: `/opsx-propose`, etc. |

> ¿Te creó una carpeta `.agent/` (en singular)? Tu OpenSpec es una versión
> antigua. Actualízala (ver [Mantenerlo actualizado](#mantenerlo-actualizado)) y
> vuelve a ejecutar el comando.

¿Quieres que los documentos se generen en español? Agrega `--language`:

```bash
openspec init --tools antigravity --language "Spanish"
```

> En la industria la mayoría de los equipos escriben las specs en inglés. Si
> quieres practicar, deja el valor por defecto.

**Comprobación:** tu proyecto debe tener ahora esta estructura:

```text
mi-proyecto/
├── openspec/
│   ├── specs/          # las specs del proyecto (la fuente de verdad)
│   ├── changes/        # los cambios propuestos
│   └── config.yaml     # configuración
└── .agents/
    ├── skills/         # para Antigravity CLI
    └── workflows/      # para Antigravity 2.0 / IDE
```

Al terminar, `openspec init` imprime un mensaje con **la forma exacta de escribir
los comandos** en las herramientas que elegiste. Léelo.

## Primer uso con Antigravity CLI

1. En la carpeta del proyecto ejecuta `agy`.
2. Escribe `/` y busca los comandos de OpenSpec. En la CLI aparecen como skills:
   `/openspec-explore`, `/openspec-propose`, `/openspec-apply-change`,
   `/openspec-archive-change`.
3. Prueba con algo pequeño:

   ```text
   /openspec-propose agregar una pantalla de inicio con el nombre de la app
   ```

4. Abre `openspec/changes/<nombre-del-cambio>/` y **lee los cuatro archivos**.
   Si algo no es lo que querías, corrígelo o pídele al agente que lo corrija.
   **Solo cuando estés de acuerdo**, ejecuta `/openspec-apply-change`.

En Antigravity 2.0 / IDE los mismos comandos aparecen como `/opsx-propose`,
`/opsx-apply`, etc.

## Mantenerlo actualizado

```bash
npm install -g @fission-ai/openspec@latest
openspec update
```

`openspec update` se ejecuta **dentro de cada proyecto** para regenerar las
instrucciones del agente con la versión nueva.

## Problemas comunes

**`openspec: command not found` después de instalar**
Abre una terminal nueva. Si sigue fallando, revisa que la carpeta global de npm
esté en tu `PATH`: `npm prefix -g` te dice dónde está.

**En Windows: `la ejecución de scripts está deshabilitada en este sistema`**
PowerShell bloquea los scripts de npm. Ejecuta una vez:
`Set-ExecutionPolicy -Scope CurrentUser RemoteSigned` y abre una ventana nueva.

**Los comandos `/openspec-*` no aparecen en `agy`**
Revisa que exista `.agents/skills/` en tu proyecto y que ejecutaste `agy` desde
la carpeta raíz del proyecto. Si no existe, vuelve a ejecutar
`openspec init --tools antigravity`.

**`npm ERR! network` o `ETIMEDOUT`**
Tu red está bloqueando el registro de npm (pasa en algunas redes
institucionales). Prueba desde otra conexión.
