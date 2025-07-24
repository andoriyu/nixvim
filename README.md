# Nixvim Configuration

A customizable Neovim configuration using [nixvim](https://github.com/nix-community/nixvim), allowing you to manage your Neovim setup through Nix.

## Features

- **Modular Configuration**: Easily add or modify components
- **Multiple Profiles**: Choose between full-featured or lightweight setups
- **Language Support**: Preconfigured for Go, Rust, Elixir, Terraform, Docker, and web development
- **Docker Integration**: Run your configuration in containers
- **Cachix Support**: Faster builds with pre-built binaries
- **GitHub Actions**: Automated testing across platforms

## Quick Start

Run the default (lite) configuration:

```bash
nix run .
```

Run the full configuration with all language support:

```bash
nix run .#nvim-full
```

### Home Manager Integration

Add to your Home Manager configuration:

```nix
{
  inputs.coldsteel-nixvim.url = "github:andoriyu/nixvim";
  
  outputs = { self, nixpkgs, home-manager, coldsteel-nixvim, ... }: {
    homeConfigurations."username" = home-manager.lib.homeManagerConfiguration {
      # ...
      modules = [
        coldsteel-nixvim.homeManagerModules.default
        {
          coldsteel.nixvim = {
            enable = true;
            defaultEditor = true;
            
            # Enable specific language support
            go = true;
            rust = true;
            elixir = true;
            
            # Or use a preset configuration
            # preset = "full";  # Options: "none", "lite", "full", "custom"
          };
        }
      ];
    };
  };
}
```

### Using the Library Function

You can also use the provided library function to create a custom configuration:

```nix
{
  environment.systemPackages = [
    (inputs.coldsteel-nixvim.lib.mkNixvim {
      system = pkgs.system;
      go = true;
      rust = true;
      elixir = true;
      none-ls = true;
    })
  ];
}
```

## Configuration Profiles

### Full Profile

Includes comprehensive language support and plugins:

```bash
nix run .#nvim-full
```

### Lite Profile

A minimal configuration without language-specific plugins:

```bash
nix run .#nvim-lite
```

## Docker Images

Run your configuration in Docker:

```bash
# Build the full Docker image
nix build .#docker-full

# Build the lite Docker image
nix build .#docker-lite
```

## Customization

### Adding New Plugins

1. Create a new `.nix` file in the `config/` directory
2. Add your plugin configuration
3. The file will be automatically imported

### Modifying Language Support

Edit `full.nix` or `lite.nix` to enable/disable specific language support:

```nix
{
  imports = [./config];

  coldsteel = {
    go = true;        # Go support
    docker = true;    # Docker support
    terraform = true; # Terraform support
    web = true;       # Web development support
    rust = true;      # Rust support
    elixir = true;    # Elixir support
    none-ls = true;   # None-LS support
  };
}
```

## Testing

Verify your configuration:

```bash
nix flake check .
```

## Repository Structure

```
.
├── config/                  # Main configuration directory
│   ├── autopairs.nix        # Auto-pairs plugin configuration
│   ├── bufferline.nix       # Buffer line plugin configuration
│   ├── colors.nix           # Color scheme configuration
│   ├── default.nix          # Main configuration entry point
│   ├── keymappings.nix      # Keyboard mappings
│   ├── lsp.nix              # Language Server Protocol configuration
│   ├── lualine.nix          # Status line configuration
│   ├── none-ls.nix          # None-LS (null-ls) configuration
│   ├── oil.nix              # Oil.nvim file explorer configuration
│   ├── options.nix          # Neovim options
│   ├── telescope.nix        # Telescope fuzzy finder configuration
│   └── treesitter.nix       # Treesitter configuration
├── flake.nix                # Nix flake configuration
├── full.nix                 # Full configuration profile
├── lite.nix                 # Lite configuration profile
├── module.nix               # Custom module options
└── README.md                # Documentation
```

## Core Plugins

Always enabled in both configurations:

- `indent-blankline`: Indentation guides
- `illuminate`: Highlights other uses of the word under cursor
- `rainbow-delimiters`: Colorizes nested parentheses and brackets
- `web-devicons`: File icons

## Advanced Configuration

For more advanced configuration:

1. Modify `module.nix` to add new options
2. Edit `flake.nix` to change dependencies or add packages
3. Create new configuration profiles

## Cachix Integration

This repository uses Cachix for faster builds:

```
extra-substituters = [
  "https://nix-community.cachix.org"
  "https://andoriyu-nixvim.cachix.org"
]
```

## GitHub Actions

Automated testing across platforms:
- x86_64-linux
- aarch64-darwin

## Hotkeys and Keybindings

The configuration uses `,` (comma) as the leader key. Here are all the available hotkeys:

### File Operations
- `,n` - Open Oil file browser
- `,v` - Create vertical split
- `,h` - Create horizontal split

### Telescope (Fuzzy Finder)
- `,ff` - Find files
- `,fw` - Live grep (search in files)
- `,fg` - Git commits
- `,fh` - Recent files (oldfiles)
- `,fm` - Man pages
- `,ch` - Change colorscheme

### LSP (Language Server Protocol)
- `,lf` - Format current buffer
- `,lo` - Organize imports
- `,li` - Add missing imports

### Elixir Development (when enabled)
- `,em` - Run mix test
- `,ec` - Run mix compile
- `,ed` - Get mix dependencies
- `,ef` - Format current Elixir file

### Completion (nvim-cmp)
- `<Tab>` - Select next completion item / expand snippet
- `<S-Tab>` - Select previous completion item / jump back in snippet
- `<CR>` - Confirm completion
- `<C-Space>` - Trigger completion manually
- `<C-e>` - Abort completion
- `<Up>` / `<C-p>` - Select previous item
- `<Down>` / `<C-n>` - Select next item
- `<C-u>` - Scroll documentation up
- `<C-d>` - Scroll documentation down

### Default Vim/Neovim Bindings
These standard bindings are also available:
- `<C-w>` + direction - Navigate between splits
- `:` - Command mode
- `/` - Search forward
- `?` - Search backward
- `n` / `N` - Next/previous search result
- `u` - Undo
- `<C-r>` - Redo
- `dd` - Delete line
- `yy` - Yank (copy) line
- `p` / `P` - Paste after/before cursor

### Visual Mode
- `v` - Enter visual mode
- `V` - Enter visual line mode
- `<C-v>` - Enter visual block mode

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open source and available under the [MIT License](LICENSE).
