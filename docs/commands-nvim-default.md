# Comandos Base de Neovim

> Comandos y atajos por defecto de Neovim y plugins comunes.

## Navegación y búsqueda

| Tecla | Acción |
| ----- | ------ |
| `<Esc>` | Limpiar resaltado de búsqueda |
| `]d` | Siguiente diagnóstico |
| `[d` | Diagnóstico anterior |
| `]e` | Siguiente error |
| `[e` | Error anterior |

## Ventanas y splits

| Tecla | Acción |
| ----- | ------ |
| `<C-w>h` | Mover foco a la ventana izquierda |
| `<C-w>l` | Mover foco a la ventana derecha |
| `<C-w>k` | Mover foco a la ventana superior |
| `<C-w>j` | Mover foco a la ventana inferior |
| `<C-w>v` | Split vertical |
| `<C-w>s` | Split horizontal |
| `<C-w>c` | Cerrar ventana actual |
| `<C-w>q` | Cerrar ventana y buffer |

## Comandos de plugins

| Comando | Plugin | Acción |
| ------- | ------ | ------ |
| `:Lazy sync` | lazy.nvim | Sincronizar todos los plugins |
| `:MasonInstallAll` | mason.nvim | Instalar todas las herramientas |
| `:TSInstallAll` | nvim-treesitter | Instalar todos los parsers |
| `:MruFile` | mru-nav.nvim | Abrir archivo más reciente |
| `:MruBuffer` | mru-nav.nvim | Cambiar al buffer más reciente |
| `:MruClearFiles` | mru-nav.nvim | Limpiar historial de archivos |
| `:Mason` | mason.nvim | Abrir panel de Mason |
| `:Telescope` | telescope.nvim | Abrir Telescope |
| `:NvimTreeToggle` | nvim-tree.lua | Abrir/cerrar explorador |
| `:NvimTreeFocus` | nvim-tree.lua | Enfocar explorador |
| `:Codex` | codex.nvim | Abrir Codex |
| `:CodexToggle` | codex.nvim | Toggle Codex |
| `:Copilot` | copilot.lua | Comando de Copilot |
| `:Huefy` | minty | Selector de colores |
| `:Shades` | minty | Variaciones de color |
| `:WhichKey` | which-key.nvim | Mostrar keymaps disponibles |
| `:AerialToggle` | aerial.nvim | Toggle árbol de símbolos |
| `:AerialPrev` | aerial.nvim | Símbolo anterior |
| `:AerialNext` | aerial.nvim | Símbolo siguiente |
| `:TodoTelescope` | todo-comments.nvim | Buscar TODOs en Telescope |
| `:TodoQuickFix` | todo-comments.nvim | Buscar TODOs en quickfix |
| `:GitBlameToggle` | git-blame.nvim | Toggle git-blame |

## LSP por defecto

| Tecla | Acción |
| ----- | ------ |
| `gr` | Ver referencias del símbolo |
| `gd` | Ir a definición |
| `gD` | Ir a declaración |
| `gi` | Ir a implementación |
| `K` | Mostrar documentación (hover) |
