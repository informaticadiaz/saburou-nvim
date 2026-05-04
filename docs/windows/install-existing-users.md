# Instalación en Windows — Usuarios existentes de Neovim

> [!NOTE]
>
> Esta guía está pensada para personas que **ya tienen Neovim instalado** en Windows y quieren probar o migrar a
> esta configuración sin perder su configuración actual.

## Índice

- [Requisitos](#requisitos)
- [Hacer backup de tu configuración actual](#hacer-backup-de-tu-configuración-actual)
  - [Identificar dónde está tu configuración](#identificar-dónde-está-tu-configuración)
  - [Hacer backup usando PowerShell](#hacer-backup-usando-powershell)
  - [Hacer backup usando cmd](#hacer-backup-usando-cmd)
  - [Qué se está respaldando](#qué-se-está-respaldando)
- [Clonar esta configuración](#clonar-esta-configuración)
  - [Opción A: Instalación aislada con `NVIM_APPNAME` (recomendada)](#opción-a-instalación-aislada-con-nvim_appname-recomendada)
  - [Opción B: Reemplazar tu configuración actual](#opción-b-reemplazar-tu-configuración-actual)
  - [Opción C: Backup completo + instalación limpia](#opción-c-backup-completo--instalación-limpia)
- [Primer arranque](#primer-arranque)
- [Volver a tu configuración anterior](#volver-a-tu-configuración-anterior)
- [Solución de problemas](#solución-de-problemas)

## Requisitos

- **Neovim 0.12 o superior** ya instalado en tu sistema. Comprueba tu versión con:

  ```cmd
  nvim --version
  ```

- `git` instalado y disponible en el `PATH`.
- Una _Nerd Font_ configurada en tu terminal para los iconos.

## Hacer backup de tu configuración actual

Antes de tocar nada, haz una copia de seguridad de tu configuración actual. Así podrás volver a ella en cualquier momento.

### Identificar dónde está tu configuración

Neovim busca su configuración en el director `nvim` dentro de tu carpeta de configuración. En Windows, la ruta depende
de si usas una instalación normal o una instalación aislada con `NVIM_APPNAME`.

Para encontrar tu configuración actual, abre Neovim y ejecuta:

```vim
:echo stdpath('config')
```

Esto te mostrará la ruta exacta. Lo más común en Windows es:

```text
C:\Users\<tu-usuario>\AppData\Local\nvim
```

Si usas `NVIM_APPNAME=saburou`, la ruta sería:

```text
C:\Users\<tu-usuario>\AppData\Local\saburou
```

### Hacer backup usando PowerShell

Abre PowerShell y ejecuta:

```powershell
# Define las rutas (ajusta si tu configuración está en otro lugar)
$nvimConfig = "$env:LOCALAPPDATA\nvim"
$backupPath = "$env:USERPROFILE\Desktop\nvim-backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

# Crea el backup
if (Test-Path $nvimConfig) {
    Copy-Item -Path $nvimConfig -Destination $backupPath -Recurse
    Write-Host "Backup creado en: $backupPath"
} else {
    Write-Host "No se encontró configuración en: $nvimConfig"
}
```

Esto crea una carpeta en tu escritorio con la fecha y hora actual, por ejemplo:

```text
C:\Users\<tu-usuario>\Desktop\nvim-backup-20250503-143022
```

### Hacer backup usando cmd

Si prefieres usar `cmd`, puedes hacer lo mismo:

```cmd
set "nvimConfig=%LOCALAPPDATA%\nvim"
set "backupPath=%USERPROFILE%\Desktop\nvim-backup"
xcopy "%nvimConfig%" "%backupPath%\" /E /I /H
echo Backup creado en: %backupPath%
```

### Qué se está respaldando

El backup incluye:

| Carpeta / Archivo | Contenido |
|-------------------|-----------|
| `init.lua` o `init.vim` | Tu archivo de configuración principal |
| `lua/` | Módulos Lua personalizados |
| `plugin/` | Plugins instalados manualmente |
| `after/` | Configuraciones que se cargan después |
| `spell/` | Diccionarios de corrección ortográfica |

> [!WARNING]
>
> El backup **no** incluye los datos de estado de Neovim (cachés, undo files, sesiones), que viven en
> `%LOCALAPPDATA%\nvim-data\` (cmd) o `$env:LOCALAPPDATA\nvim-data` (PowerShell).
> Estos no necesitas respaldarlos para recuperar tu configuración.

## Clonar esta configuración

### Opción A: Instalación aislada con `NVIM_APPNAME` (recomendada)

Esta opción te permite usar esta configuración **sin tocar tu configuración actual**. Ambas coexisten y puedes
alternar entre ellas.

1. **Elige un nombre para la configuración aislada**, por ejemplo `saburou`.

2. **Clona el repositorio** en la ruta correspondiente:

   #### cmd

   ```cmd
   git clone https://github.com/heizeisaburou/saburou-nvim "%LOCALAPPDATA%\saburou"
   ```

   #### PowerShell

   ```powershell
   git clone https://github.com/heizeisaburou/saburou-nvim "$env:LOCALAPPDATA\saburou"
   ```

3. **Abre Neovim con la configuración aislada**:

   #### cmd

   ```cmd
   set NVIM_APPNAME=saburou
   nvim
   ```

   O en una sola línea:

   ```cmd
   cmd /C "set NVIM_APPNAME=saburou&& nvim"
   ```

   #### PowerShell

   ```powershell
   $env:NVIM_APPNAME = "saburou"; nvim
   ```

4. **Crea un alias o función para no tener que escribir la variable cada vez.**

   #### PowerShell (perfil permanente)

   Edita tu perfil de PowerShell:

   ```powershell
   notepad $PROFILE
   ```

   Añade esta función:

   ```powershell
   function nvim-saburou {
       $env:NVIM_APPNAME = "saburou"
       nvim @args
       Remove-Item Env:\NVIM_APPNAME -ErrorAction SilentlyContinue
   }
   ```

   Después recarga el perfil:

   ```powershell
   . $PROFILE
   ```

   Ahora puedes abrir la configuración con:

   ```powershell
   nvim-saburou
   ```

   #### cmd (alias temporal por sesión)

   ```cmd
   doskey nvim-saburou=cmd /C "set NVIM_APPNAME=saburou^^^&^^^& nvim $*"
   ```

   > [!NOTE]
   >
   > `doskey` solo dura la sesión actual. Para hacerlo permanente, guarda el comando en un archivo `.bat` en una
   > carpeta del `PATH` o usa un script de inicio.

### Opción B: Reemplazar tu configuración actual

> [!WARNING]
>
> Esta opción **sobrescribe** tu configuración actual. Asegúrate de haber hecho el backup primero.

> [!IMPORTANT]
>
> `%VAR%` es sintaxis de **cmd**. En PowerShell usá `$env:VAR`. No mezcles las sintaxis.

1. **Renombra tu configuración actual** (si no hiciste backup antes):

   #### cmd

   ```cmd
   ren "%LOCALAPPDATA%\nvim" "nvim-old"
   ```

   #### PowerShell

   ```powershell
   Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-old"
   ```

2. **Clona el repositorio** en su lugar:

   #### cmd

   ```cmd
   git clone https://github.com/heizeisaburou/saburou-nvim "%LOCALAPPDATA%\nvim"
   ```

   #### PowerShell

   ```powershell
   git clone https://github.com/heizeisaburou/saburou-nvim "$env:LOCALAPPDATA\nvim"
   ```

3. **Abre Neovim normalmente**:

   ```cmd
   nvim
   ```

   #### PowerShell

   ```powershell
   Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-old"
   ```

2. **Clona el repositorio** en su lugar:

   #### cmd

   ```cmd
   git clone https://github.com/heizeisaburou/saburou-nvim "%LOCALAPPDATA%\nvim"
   ```

   #### PowerShell

   ```powershell
   git clone https://github.com/heizeisaburou/saburou-nvim "$env:LOCALAPPDATA\nvim"
   ```

3. **Abre Neovim normalmente**:

   ```cmd
   nvim
   ```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-old"
git clone https://github.com/heizeisaburou/saburou-nvim "$env:LOCALAPPDATA\nvim"
nvim
```

### Opción C: Backup completo + instalación limpia

Esta opción es para quienes quieren **reemplazar por completo** su configuración anterior, incluyendo los datos
de estado (plugins, cachés, undo files). Es la opción más limpia si no planeas volver a tu configuración anterior.

> [!WARNING]
>
> Esta opción elimina tu configuración y datos actuales. El backup es obligatorio.

1. **Hacer backup de tu configuración actual** (si aún no lo hiciste):

   ```powershell
   $nvimConfig = "$env:LOCALAPPDATA\nvim"
   $backupPath = "$env:USERPROFILE\Desktop\nvim-backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
   if (Test-Path $nvimConfig) {
       Copy-Item -Path $nvimConfig -Destination $backupPath -Recurse
       Write-Host "Backup creado en: $backupPath"
   }
   ```

2. **Cerrar Neovim** si está abierto.

3. **Borrar los datos de estado** de tu configuración anterior (plugins, cachés, etc.):

   ```powershell
   Remove-Item -Path "$env:LOCALAPPDATA\nvim-data" -Recurse -Force
   ```

   > [!IMPORTANT]
   >
   > Este comando **NO funciona con `rmdir /s /q`** si estás en PowerShell. Si prefieres usar `rmdir`,
   > abre `cmd.exe` en vez de PowerShell. Consulta la [guía de solución de problemas](troubleshooting.md)
   > si recibes errores de permisos.

   Si tu configuración anterior usaba un `NVIM_APPNAME` personalizado, ajusta la ruta:

   ```powershell
   Remove-Item -Path "$env:LOCALAPPDATA\<tu-appname>-data" -Recurse -Force
   ```

4. **Borrar la configuración actual**:

   ```powershell
   Remove-Item -Path "$env:LOCALAPPDATA\nvim" -Recurse -Force
   ```

   O si usabas un `NVIM_APPNAME` personalizado:

   ```powershell
   Remove-Item -Path "$env:LOCALAPPDATA\<tu-appname>" -Recurse -Force
   ```

5. **Clonar esta configuración** en su lugar:

   ```powershell
   git clone https://github.com/heizeisaburou/saburou-nvim "$env:LOCALAPPDATA\nvim"
   ```

6. **Abre Neovim normalmente**:

   ```powershell
   nvim
   ```

## Primer arranque

La primera vez que abras Neovim con esta configuración, `lazy.nvim` instalará automáticamente todos los plugins.

Cuando termine, ejecuta dentro de Neovim:

```vim
:Lazy sync
:MasonInstallAll
:TSInstallAll
```

> [!TIP]
>
> Si algo falla durante la instalación, puedes reintentar con `:Lazy sync` en cualquier momento.

## Volver a tu configuración anterior

Si usaste la **Opción A (aislada)**, simplemente vuelve a abrir Neovim sin la variable `NVIM_APPNAME`:

```cmd
nvim
```

Si usaste la **Opción B (reemplazo)** y quieres recuperar tu configuración:

#### cmd

```cmd
ren "%LOCALAPPDATA%\nvim" "nvim-saburou"
ren "%USERPROFILE%\Desktop\nvim-backup-YYYYMMDD-HHMMSS" "nvim"
:: O si solo renombraste a nvim-old:
:: ren "%LOCALAPPDATA%\nvim-old" "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

#### PowerShell

```powershell
Rename-Item -Path "$env:LOCALAPPDATA\nvim" -NewName "nvim-saburou"
Rename-Item -Path "$env:USERPROFILE\Desktop\nvim-backup-YYYYMMDD-HHMMSS" -NewName "nvim"
# O si solo renombraste a nvim-old:
# Rename-Item -Path "$env:LOCALAPPDATA\nvim-old" -NewName "nvim"
nvim
```

## Solución de problemas

Si tienes problemas de permisos al borrar carpetas de datos o errores de rutas demasiado largas,
consulta la [guía de solución de problemas](troubleshooting.md).
