# Comandos y Keymaps — saburou-nvim

> Leader: `<space>` | Local leader: `<space>`

## Navegación y búsqueda

| Tecla | Acción |
| ----- | ------ |
| `<leader>ff` | Buscar archivos (Telescope) |
| `<leader>fg` | Buscar texto en el proyecto (Telescope live grep) |
| `<leader>fb` | Buscar buffers abiertos |
| `<leader>fo` | Buscar archivos recientes |
| `<leader>ft` | Buscar comentarios TODO/FIX/NOTE |
| `<Esc>` | Limpiar resaltado de búsqueda |
| `;` | Entrar en modo comando (`:`) |

## Buffers y archivos

| Tecla | Acción |
| ----- | ------ |
| `<C-s>` | Guardar buffer actual |
| `<C-A-s>` | Guardar todos los buffers |
| `<A-x>` | Cerrar buffer (reemplazar ventana) |
| `<A-c>` | Cerrar buffer (cerrar ventana) |
| `<C-A-x>` | Cerrar todos los buffers (reemplazar ventanas) |
| `<C-A-q>` | Cerrar todos los buffers y salir |
| `ñ` | Agregar línea debajo del cursor |
| `Ñ` | Agregar línea arriba del cursor |
| `U` | Redo |
| `:Bp` | Ir al buffer anterior |

## Editor — recortes (`<leader>`)

Combinación: `<leader>` + **categoría** + **objeto**

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

## Ventanas y splits

| Tecla | Acción |
| ----- | ------ |
| `<C-h>` | Mover foco a la ventana izquierda |
| `<C-l>` | Mover foco a la ventana derecha |
| `<C-k>` | Mover foco a la ventana superior |
| `<C-j>` | Mover foco a la ventana inferior |
| `<A-h>` | Scroll horizontal rápido izquierda |
| `<A-l>` | Scroll horizontal rápido derecha |
| `<A-H>` | Scroll horizontal izquierda |
| `<A-L>` | Scroll horizontal derecha |

## Terminal

| Tecla | Acción |
| ----- | ------ |
| `<A-v>` | Terminal en split vertical |
| `<A-b>` | Terminal en split horizontal |
| `<A-i>` | Toggle terminal flotante (normal/terminal) |
| `<C-x>` | Salir de modo terminal (en terminal mode) |

## LSP y código

| Tecla | Acción |
| ----- | ------ |
| `gr` | Ver referencias del símbolo bajo el cursor |
| `<C-A-r>` | Renombrar símbolo |
| `{` | Símbolo anterior (Aerial) |
| `}` | Símbolo siguiente (Aerial) |
| `<leader>q` | Toggle árbol de símbolos (Aerial) |
| `<C-q>` | Toggle árbol de símbolos (Aerial) |

## Git

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

## Sesiones y reinicio

| Tecla / Comando | Acción |
| --------------- | ------ |
| `<A-r>` | Reiniciar Neovim (preserva buffers y sesiones) |
| `:Re` | Reiniciar Neovim (comando) |

## Clipboard

| Tecla | Acción |
| ----- | ------ |
| `<C-c>` | Copiar todo el contenido del buffer al clipboard del sistema |

## UI

| Tecla | Acción |
| ----- | ------ |
| Click derecho | Abrir menú contextual (volt/menu) |

## Comandos de Neovim

| Comando | Acción |
| ------- | ------ |
| `:Lazy sync` | Sincronizar todos los plugins |
| `:MasonInstallAll` | Instalar todas las herramientas de Mason |
| `:TSInstallAll` | Instalar todos los parsers de Treesitter |
| `:MruFile` | Abrir archivo más reciente usado |
| `:MruBuffer` | Cambiar al buffer más reciente usado |
| `:MruClearFiles` | Limpiar historial de archivos recientes |
| `:Mason` | Abrir panel de Mason |
| `:Telescope` | Abrir Telescope |
| `:NvimTreeToggle` | Abrir/cerrar explorador de archivos |
| `:NvimTreeFocus` | Enfocar explorador de archivos |
| `:Codex` | Abrir Codex |
| `:CodexToggle` | Toggle Codex |
| `:Copilot` | Comando de Copilot |
| `:Huefy` | Selector de colores |
| `:Shades` | Variaciones de color |
| `:WhichKey` | Mostrar keymaps disponibles |

## Diagnósticos

Los diagnósticos LSP se muestran inline con iconos:

| Icono | Severidad |
| ----- | --------- |
| `󰅙` | Error |
| `` | Warning |
| `󰋼` | Info |
| `󰌵` | Hint |

Navegación por defecto de Neovim:
- `]d` — siguiente diagnóstico
- `[d` — diagnóstico anterior
- `]e` — siguiente error
- `[e` — error anterior
