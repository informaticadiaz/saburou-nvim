# Comandos Exclusivos — saburou-nvim

> Keymaps y comandos propios de esta configuración. No vienen en Neovim por defecto.
>
> Leader: `<space>`

## Buffers y archivos (hzsr)

| Tecla | Acción |
| ----- | ------ |
| `<C-s>` | Guardar buffer actual |
| `<C-A-s>` | Guardar todos los buffers |
| `<A-x>` | Cerrar buffer (reemplazar ventana) |
| `<A-c>` | Cerrar buffer (cerrar ventana) |
| `<C-A-x>` | Cerrar todos los buffers (reemplazar ventanas) |
| `<C-A-q>` | Cerrar todos los buffers y salir |
| `:Bp` | Ir al buffer anterior |

## Editor — recortes (`<leader>`)

Sistema propio de recortes: `<leader>` + **categoría** + **objeto**

### Categorías

| Tecla | Acción |
| ----- | ------ |
| `d` | Borrar sin copiar |
| `D` | Borrar copiando al registro |
| `e` | Borrar sin copiar y entrar en insert |
| `c` | Borrar copiando y entrar en insert |

### Objetos

| Tecla | Objeto |
| ----- | ------ |
| `w` | Palabra |
| `e` | Hasta fin de línea |
| `l` | Línea completa |
| `t` | Línea (misma indentación) |

### Ejemplos

| Tecla | Acción |
| ----- | ------ |
| `<leader>dw` | Borrar palabra sin copiar |
| `<leader>Dw` | Borrar palabra copiando |
| `<leader>el` | Borrar línea e insertar |
| `<leader>ct` | Borrar línea con indentación, copiar e insertar |

### Sufijos rápidos

| Tecla | Acción |
| ----- | ------ |
| `<leader>;` | Agregar `;` al final de la línea |
| `<leader>,` | Agregar `,` al final de la línea |

## Teclado español

| Tecla | Acción |
| ----- | ------ |
| `ñ` | Agregar línea debajo del cursor |
| `Ñ` | Agregar línea arriba del cursor |

## Redo

| Tecla | Acción |
| ----- | ------ |
| `U` | Redo (en vez de undo de línea) |

## Navegación custom

| Tecla | Acción |
| ----- | ------ |
| `;` | Entrar en modo comando (`:`) |
| `<C-h>` | Mover foco a ventana izquierda |
| `<C-l>` | Mover foco a ventana derecha |
| `<C-k>` | Mover foco a ventana superior |
| `<C-j>` | Mover foco a ventana inferior |
| `<A-h>` | Scroll horizontal rápido izquierda |
| `<A-l>` | Scroll horizontal rápido derecha |
| `<A-H>` | Scroll horizontal izquierda |
| `<A-L>` | Scroll horizontal derecha |

## Terminal (sabunv)

| Tecla | Acción |
| ----- | ------ |
| `<A-v>` | Terminal en split vertical |
| `<A-b>` | Terminal en split horizontal |
| `<A-i>` | Toggle terminal flotante (normal/terminal) |
| `<C-x>` | Salir de modo terminal (en terminal mode) |

## LSP custom

| Tecla | Acción |
| ----- | ------ |
| `<C-A-r>` | Renombrar símbolo |

## Aerial (custom bindings)

| Tecla | Acción |
| ----- | ------ |
| `{` | Símbolo anterior |
| `}` | Símbolo siguiente |
| `<leader>q` | Toggle árbol de símbolos |
| `<C-q>` | Toggle árbol de símbolos |

## Git (custom bindings)

| Tecla | Acción |
| ----- | ------ |
| `<leader>gC` | Ver commits (Telescope) |
| `<leader>gb` | Toggle git-blame |
| `<leader>gco` | Resolver conflicto: usar nuestra versión |
| `<leader>gct` | Resolver conflicto: usar su versión |
| `<leader>gcb` | Resolver conflicto: usar ambas |
| `<leader>gc0` | Resolver conflicto: usar ninguna |
| `<leader>gcp` | Ir al conflicto anterior |
| `<leader>gcn` | Ir al siguiente conflicto |

## IA

### Copilot

| Tecla | Modo | Acción |
| ----- | ---- | ------ |
| `<leader>gt` | normal | Toggle Copilot |
| `<leader>ge` | normal | Habilitar Copilot |
| `<leader>gd` | normal | Deshabilitar Copilot |
| `<leader>gs` | normal | Ver estado de Copilot |
| `<C-]>` | insert | Descartar sugerencia |
| `<C-\>` | insert | Mostrar sugerencia |
| `<A-]>` | insert | Siguiente sugerencia |
| `<A-[>` | insert | Sugerencia anterior |
| `<A-Right>` | insert | Aceptar palabra |
| `<A-\>` | insert | Aceptar línea |
| `<A-CR>` | insert | Aceptar sugerencia completa |

### Claude Code

| Tecla | Modo | Acción |
| ----- | ---- | ------ |
| `<C-,>` | normal/terminal | Toggle Claude Code |
| `<leader>,c` | normal | Continuar conversación |
| `<leader>,v` | normal | Modo verbose |
| `<leader>,r` | normal | Reanudar conversación (picker) |

### Codex

| Tecla | Modo | Acción |
| ----- | ---- | ------ |
| `<C-.>` | normal/terminal | Toggle Codex popup/panel |

## Sesiones y reinicio (sabunv)

| Tecla / Comando | Acción |
| --------------- | ------ |
| `<A-r>` | Reiniciar Neovim (preserva buffers y sesiones) |
| `:Re` | Reiniciar Neovim (comando) |

## Clipboard

| Tecla | Acción |
| ----- | ------ |
| `<C-c>` | Copiar todo el buffer al clipboard del sistema |

## UI

| Tecla | Acción |
| ----- | ------ |
| Click derecho | Abrir menú contextual (volt/menu) |

## Insert helpers

| Tecla | Modo | Acción |
| ----- | ---- | ------ |
| `<S-Tab>` | insert | Insertar tabulación real (`\t`) |

## Diagnósticos custom

Iconos configurados para diagnósticos LSP:

| Icono | Severidad |
| ----- | --------- |
| `󰅙` | Error |
| `` | Warning |
| `󰋼` | Info |
| `󰌵` | Hint |
