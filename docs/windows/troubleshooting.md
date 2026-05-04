# Solución de problemas en Windows

Guía de problemas comunes y sus soluciones al usar esta configuración en Windows.

## Índice

- [Error de permisos al borrar `nvim-data`](#error-de-permisos-al-borrar-nvim-data)
- [Paths demasiado largos (MAX_PATH)](#paths-demasiado-largos-max_path)

## Error de permisos al borrar `nvim-data`

Si al intentar borrar la carpeta `nvim-data` (o cualquier carpeta que contenga repositorios de plugins) recibes errores como:

```
Remove-Item: You do not have sufficient access rights to perform this operation
Directory ...\.git\objects\pack cannot be removed because it is not empty
```

Esto pasa porque **Git marca los archivos `.git/objects/pack/*.pack` como read-only** en Windows, y PowerShell no los borra por defecto. Además, las rutas dentro de `.git` pueden exceder el límite `MAX_PATH` (260 caracteres).

### Solución 1: Usar `cmd` con `rmdir` (más simple)

> [!IMPORTANT]
>
> Este comando **NO funciona en PowerShell**. En PowerShell, `rmdir` es un alias de `Remove-Item` que no acepta
> `/s /q`. Abre `cmd.exe` (no PowerShell) para usarlo.

Abre **cmd.exe** (no PowerShell) y ejecuta:

```cmd
rmdir /s /q "%LOCALAPPDATA%\nvim-data"
```

Si tu carpeta tiene otro nombre o está en otra ruta, ajústala:

```cmd
rmdir /s /q "%LOCALAPPDATA%\saburou-data"
```

#### Equivalente en PowerShell

Si prefieres quedarte en PowerShell, usa este comando en vez de `rmdir`:

```powershell
Remove-Item -Path "$env:LOCALAPPDATA\nvim-data" -Recurse -Force
```

### Solución 2: Quitar el atributo read-only primero

Si `rmdir` tampoco funciona, quita el atributo read-only de todos los archivos antes de borrar:

```cmd
attrib -R "%LOCALAPPDATA%\nvim-data\*.*" /s /d
rmdir /s /q "%LOCALAPPDATA%\nvim-data"
```

O en PowerShell:

```powershell
Get-ChildItem -Path "$env:LOCALAPPDATA\nvim-data" -Recurse -Force |
    ForEach-Object { $_.IsReadOnly = $false }
Remove-Item -Path "$env:LOCALAPPDATA\nvim-data" -Recurse -Force
```

### Solución 3: Borrar desde el Explorador de Windows

Si nada funciona desde la terminal:

1. Abre el Explorador de archivos y navega a `%LOCALAPPDATA%`
2. Haz clic derecho en la carpeta `nvim-data` (o la que corresponda)
3. Selecciona **Eliminar**
4. Si aparece un diálogo de permisos, confirma con **Continuar**

El Explorador de Windows tiene un manejo más robusto de permisos y paths largos.

### Solución 4: Desde Neovim con `:Lazy`

Si solo quieres limpiar los plugins instalados por `lazy.nvim`:

1. Abre Neovim
2. Ejecuta `:Lazy clean` para eliminar plugins que ya no están en tu configuración
3. Si quieres un reset completo, cierra Neovim y aplica las soluciones anteriores

## Paths demasiado largos (MAX_PATH)

Windows tiene un límite de 260 caracteres para las rutas. Los repositorios de plugins con estructuras profundas (especialmente `.git/objects/`) pueden superarlo.

Si ves errores como:

```
The specified path, file name, or both are too long
```

### Habilitar paths largos en Windows 10/11

1. Abre el **Editor de Registro** (`regedit`)
2. Navega a:

   ```
   HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem
   ```

3. Cambia el valor de `LongPathsEnabled` de `0` a `1`
4. Reinicia el equipo

O desde PowerShell **como administrador**:

```powershell
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name "LongPathsEnabled" -Value 1
```

> [!NOTE]
>
> Git para Windows también necesita tener habilitado `core.longpaths`. Si instalaste Git recientemente,
> ya debería estar activado. Puedes verificarlo con:
>
> ```cmd
> git config --system core.longpaths
> ```
>
> Si devuelve `true`, está habilitado. Si no, actívalo con:
>
> ```cmd
> git config --system core.longpaths true
> ```
