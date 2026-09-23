# Instalar Antigravity CLI

**Antigravity CLI** (`agy`) es el agente de programación de Google para la
terminal: lee tu proyecto, propone cambios en varios archivos y ejecuta comandos,
**siempre pidiéndote permiso**. Es la misma máquina de Antigravity 2.0, sin la
interfaz gráfica.

Fuente oficial: [antigravity.google/docs/cli/install](https://antigravity.google/docs/cli/install/)

## Antes de empezar

| | |
| --- | --- |
| **Sistema** | macOS, Linux o Windows, de 64 bits (Intel/AMD o ARM) |
| **Cuenta** | Una cuenta de Google para iniciar sesión |
| **Permisos** | **No** necesitas administrador: se instala dentro de tu carpeta de usuario |
| **Tiempo** | 5 minutos |

## Lee antes de ejecutar

Los comandos de instalación descargan un script de internet y lo ejecutan en ese
mismo instante. Es una práctica común, pero **solo es segura si confías en quien
publica el script**. Antes de pegarlo, ábrelo en el navegador y léelo:

- macOS / Linux: <https://antigravity.google/cli/install.sh>
- Windows: <https://antigravity.google/cli/install.ps1>

Vas a ver que hace poco: detecta tu sistema, descarga el binario, **comprueba su
huella SHA-512** y lo copia a tu carpeta de usuario. Acostúmbrate a hacer esto
con cualquier `curl ... | bash` que te encuentres.

---

## macOS

1. Abre la app **Terminal**.
2. Ejecuta:

   ```bash
   curl -fsSL https://antigravity.google/cli/install.sh | bash
   ```

3. **Cierra la terminal y abre una nueva.** El instalador agrega `~/.local/bin`
   a tu `PATH`, y eso solo aplica a las terminales que abras después.

**Comprobación:**

```bash
command -v agy
```

Debe imprimir `/Users/<tu-usuario>/.local/bin/agy`. Si no imprime nada, ve a
[Problemas comunes](#problemas-comunes).

## Linux

1. Abre una terminal. Necesitas `curl` (o `wget`); en Ubuntu/Debian:
   `sudo apt install curl`.
2. Ejecuta:

   ```bash
   curl -fsSL https://antigravity.google/cli/install.sh | bash
   ```

3. **Cierra la terminal y abre una nueva.**

**Comprobación:**

```bash
command -v agy
```

Debe imprimir `/home/<tu-usuario>/.local/bin/agy`.

> Las credenciales se guardan en el llavero del sistema (`libsecret`). En
> escritorios como GNOME o KDE ya viene incluido. En un servidor o WSL sin
> entorno gráfico puede faltar; revisa [Problemas comunes](#problemas-comunes).

## Windows

Usa **PowerShell** (búscalo en el menú Inicio). No hace falta abrirlo como
administrador.

1. Ejecuta:

   ```powershell
   irm https://antigravity.google/cli/install.ps1 | iex
   ```

   ¿Solo tienes **CMD**? Usa este en su lugar:

   ```cmd
   curl -fsSL https://antigravity.google/cli/install.cmd -o install.cmd && install.cmd && del install.cmd
   ```

2. **Cierra la ventana y abre una nueva.**

**Comprobación:**

```powershell
where.exe agy
```

Debe imprimir `C:\Users\<tu-usuario>\AppData\Local\agy\bin\agy.exe`.

---

## Primer inicio de sesión (todos los sistemas)

1. Entra a la carpeta de un proyecto y ejecuta:

   ```bash
   agy
   ```

2. Se abre tu navegador con el inicio de sesión de Google. Acepta los permisos.
3. Regresa a la terminal: ya estás dentro del agente.

Tu sesión queda guardada en el llavero de tu sistema (Llavero en macOS,
Administrador de credenciales en Windows, `libsecret` en Linux). La próxima vez
entras directamente.

**Comprobación final:** dentro de `agy`, escribe
`¿Qué archivos hay en esta carpeta?`. Si te responde con la lista, está listo.

Para cerrar sesión, escribe `/logout` dentro de `agy`.

## Qué aceptas al usarlo

Al usar Antigravity CLI **aceptas que Google recopile tus interacciones** para
mejorar el producto (puedes desactivarlo en la configuración). Por eso:

- **Nunca** le pegues contraseñas, tokens, llaves de API ni datos personales.
- Revisa cada comando que te pida ejecutar antes de aprobarlo. Un agente puede
  equivocarse, y quien presiona "aceptar" eres tú.

## Actualizar

No tienes que hacer nada: `agy` se actualiza solo en segundo plano.

## Desinstalar

| Sistema | Comando |
| --- | --- |
| macOS / Linux | `rm ~/.local/bin/agy` |
| Windows | `Remove-Item "$env:LOCALAPPDATA\agy\bin\agy.exe" -Force` |

Cierra sesión con `/logout` **antes** de desinstalar para borrar las
credenciales guardadas.

## Problemas comunes

**`agy: command not found` o `no se reconoce como comando`**
Casi siempre es porque no abriste una terminal nueva después de instalar. Ciérrala
y ábrela. Si sigue fallando, agrega la carpeta al `PATH` manualmente:

- macOS (zsh): `echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc`
- Linux (bash): `echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc`
- Windows: agrega `%LOCALAPPDATA%\agy\bin` a la variable `Path` de tu usuario
  (Inicio → "Editar las variables de entorno de esta cuenta").

**`Notice: 'agy' is already installed`**
Ya estaba instalado. Si quieres reinstalar desde cero, primero desinstala (ver
arriba) y vuelve a ejecutar el instalador.

**`Security Halt: The downloaded payload checksum does not match`**
La descarga llegó dañada. Vuelve a intentarlo en otra red; **no** intentes
saltarte esta comprobación.

**`Could not connect to the release server`**
Tu red bloquea la descarga (pasa en algunas redes institucionales). Prueba desde
otra conexión.

**No se abre el navegador (SSH, WSL o servidor)**
`agy` detecta que no hay navegador y te muestra un enlace. Ábrelo en el navegador
de tu computadora, inicia sesión y pega en la terminal el código que te da.

**En Linux no guarda la sesión**
Falta el llavero del sistema. En Ubuntu/Debian: `sudo apt install gnome-keyring`
y reinicia la sesión.
