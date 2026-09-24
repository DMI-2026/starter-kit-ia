# Configurar GitHub CLI (`gh`) para trabajar con el agente

**GitHub CLI** (`gh`) es la herramienta oficial de GitHub para la terminal. Con
ella puedes crear issues, abrir pull requests y revisar el estado de tu
repositorio sin salir de la terminal.

La razón de configurarla aquí: **el agente usa las mismas herramientas que tú**.
Cuando `agy` ejecuta `gh issue create`, lo hace con **tu** sesión de GitHub. Si
`gh` funciona en tu terminal, el agente puede trabajar con tus issues y PRs; si
no, no puede.

Fuentes oficiales: [cli.github.com](https://cli.github.com/) ·
[manual de `gh`](https://cli.github.com/manual/)

## Antes de empezar

| | |
| --- | --- |
| **Cuenta** | Una cuenta de GitHub. Con el [GitHub Student Developer Pack](https://education.github.com/pack) obtienes beneficios extra |
| **Git** | Instalado (`git --version` debe imprimir una versión) |
| **Tiempo** | 10 minutos |

---

## Paso 1: instalar `gh`

**macOS** (con [Homebrew](https://brew.sh)):

```bash
brew install gh
```

**Windows** (PowerShell):

```powershell
winget install --id GitHub.cli --source winget
```

Después **cierra la ventana y abre una nueva**.

**Linux — Ubuntu / Debian** (repositorio oficial de GitHub):

```bash
(type -p wget >/dev/null || (sudo apt update && sudo apt install wget -y)) \
	&& sudo mkdir -p -m 755 /etc/apt/keyrings \
	&& out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
	&& cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
	&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
	&& sudo mkdir -p -m 755 /etc/apt/sources.list.d \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
	&& sudo apt update \
	&& sudo apt install gh -y
```

**Linux — Fedora:** `sudo dnf install gh` · **Arch:** `sudo pacman -S github-cli`

**Comprobación:**

```bash
gh --version
```

Debe imprimir `gh version 2.x.x`.

## Paso 2: iniciar sesión

```bash
gh auth login --hostname github.com --git-protocol https --web
```

1. `gh` te muestra un **código de 8 caracteres** (como `ABCD-1234`). Cópialo.
2. Presiona **Enter**: se abre el navegador.
3. Pega el código, autoriza **GitHub CLI** y regresa a la terminal.
4. Si te pregunta *"Authenticate Git with your GitHub credentials?"*, responde
   **Yes**. Así `git push` usa la misma sesión y no te pide contraseña.

**Comprobación:**

```bash
gh auth status
```

Debe decir `✓ Logged in to github.com account <tu-usuario>` y
`Git operations protocol: https`.

## Paso 3: poner tu nombre en los commits

Git firma cada commit con un nombre y un correo. Usa **los mismos de tu cuenta
de GitHub**; si no, tus commits no aparecen como tuyos.

```bash
git config --global user.name "Tu Nombre"
git config --global user.email "tu-correo@ejemplo.com"
```

**Comprobación:** `git config --global user.email` imprime tu correo.

---

## Paso 4: probar `gh` tú primero

Antes de pedírselo al agente, comprueba que funciona **en tus manos**. Dentro de
un repositorio que ya esté en GitHub:

```bash
gh repo view          # datos del repositorio
gh issue list         # issues abiertas
gh pr list            # pull requests abiertos
```

Si alguno falla con `no git remotes found`, el repositorio todavía no está
conectado a GitHub. Créalo y súbelo con:

```bash
gh repo create --source . --private --push
```

## Paso 5: que el agente use `gh`

No hay que configurar nada más. Abre `agy` en la raíz del repositorio y pídele
las cosas en lenguaje normal:

| Le pides | Ejecuta algo como |
| --- | --- |
| "¿Qué issues tengo abiertas?" | `gh issue list` |
| "Crea una issue para el change `agregar-login`" | `gh issue create --title "..." --body "..."` |
| "Resume la issue 3" | `gh issue view 3` |
| "Abre un PR de mi rama hacia `main` que cierre la issue 3" | `gh pr create --base main --title "..." --body "Closes #3"` |
| "¿Pasaron las revisiones de mi PR?" | `gh pr checks` |

**Antes de ejecutar cualquier comando, `agy` te pide permiso.** Lee el comando
completo antes de aceptarlo, sobre todo el `--title` y el `--body`: eso es lo
que va a quedar publicado en GitHub con tu nombre.

### Cómo encaja con OpenSpec

Una forma ordenada de trabajar, igual que en un equipo real:

1. **Una issue por cada change** de OpenSpec. Pon el nombre del change en el
   título.
2. **Una rama por change**: `git switch -c agregar-login`.
3. Trabajas el change con el agente (`/opsx:propose`, `/opsx:apply`...).
4. **Tú** haces los commits y el `git push`. El `AGENTS.md` del curso le prohíbe
   al agente hacerlos por su cuenta; la única excepción es el commit de la
   bitácora al desbloquear el cuestionario.
5. Con la rama ya en GitHub, pídele al agente que **abra el PR** con
   `Closes #<número>` en la descripción. Al fusionar el PR, la issue se cierra
   sola.

---

## Seguridad: el agente actúa como tú

Todo lo que el agente haga con `gh` queda registrado **a tu nombre**. Por eso:

- **Nunca aceptes** sin leerlos comandos que borran o cierran cosas:
  `gh repo delete`, `gh issue close`, `gh pr close`, `gh pr merge`.
- **Nunca** le pegues ni le pidas tu token (`gh auth token`). No lo necesita:
  `gh` ya tiene tu sesión.
- Si trabajas en una computadora prestada, **cierra la sesión al terminar**:

  ```bash
  gh auth logout
  ```

## Problemas comunes

**`gh: command not found` o `no se reconoce como comando`**
Abre una terminal nueva. En Windows, si sigue fallando, reinicia la sesión de
usuario para que se actualice el `PATH`.

**`To get started with GitHub CLI, please run: gh auth login`**
No has iniciado sesión o la sesión expiró. Repite el paso 2.

**`git push` te pide usuario y contraseña**
Git no está usando la sesión de `gh`. Ejecuta `gh auth setup-git` y vuelve a
intentarlo.

**`HTTP 403` o `Resource not accessible`**
No tienes permiso sobre ese repositorio (por ejemplo, es de la organización y no
eres colaborador). Revisa con tu profesor que te hayan dado acceso.

**El agente dice que no puede usar `gh`**
Comprueba que `gh auth status` funciona en **la misma terminal** donde abriste
`agy`. Si lo instalaste después de abrir `agy`, sal de `agy`, abre una terminal
nueva y vuelve a entrar.
