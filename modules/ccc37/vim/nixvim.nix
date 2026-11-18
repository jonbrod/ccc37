{ 
  pkgs, 
  ... 
}: 
{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    globals.mapleader = " ";
    clipboard.register = "unnamedplus";

    # 1. Direnv-Integration aktivieren
    plugins.direnv = {
      enable = true;
    };

    # 2. Iron.nvim Paket aus nixpkgs zu den Neovim-Plugins hinzufügen
    extraPlugins = with pkgs.vimPlugins; [
      iron-nvim
    ];

    # 3. Lua-Konfiguration für Iron.nvim und die Keymaps ausführen
    extraConfigLua = ''
      local iron = require("iron.core")
      local common = require("iron.fts.common")

      iron.setup({
        config = {
          repl_definition = {
            python = {
              -- Dynamischer Befehl: Sucht nach IPython in .venv (inkl. --no-autoindent), sonst Fallback
              command = function()
                local cwd = vim.fn.getcwd()
                local venv_ipython = cwd .. "/.venv/bin/ipython"
                local venv_python = cwd .. "/.venv/bin/python"

                if vim.fn.executable(venv_ipython) == 1 then
                  return { venv_ipython, "--no-autoindent" }
                elseif vim.fn.executable(venv_python) == 1 then
                  return { venv_python, "--no-autoindent" }
                elseif vim.fn.executable("ipython") == 1 then
                  return { "ipython", "--no-autoindent" }
                else
                  return { "python3" }
                end
              end,
              -- Nutzt Bracketed Paste für saubere, zusammenhängende Code-Blöcke
              format = common.bracketed_paste,
            },
          },
          repl_open_cmd = require("iron.view").split.vertical.rightbelow(0.4),
        },
        keymaps = {
          send_motion = "<leader>sc",
          send_file = "<leader>sf",
          send_line = "<leader>sl",
          send_until_cursor = "<leader>su",
          send_mark = "<leader>sm",
          mark_motion = "<leader>mc",
          mark_visual = "<leader>mc",
          remove_mark = "<leader>md",
          cr = "<leader>s<cr>",
          interrupt = "<leader>s<space>",
          exit = "<leader>sq",
          clear = "<leader>cl",
        },
        ignore_blank_lines = true,
      })

      -- Keymaps für die Steuerung der REPL
      vim.keymap.set("n", "<leader>rs", "<cmd>IronRepl<cr>", { desc = "Iron REPL starten" })
      vim.keymap.set("n", "<leader>rr", "<cmd>IronRestart<cr>", { desc = "Iron REPL neustarten" })
      vim.keymap.set("n", "<leader>rf", "<cmd>IronFocus<cr>", { desc = "Iron REPL fokussieren" })
      vim.keymap.set("n", "<leader>rh", "<cmd>IronHide<cr>", { desc = "Iron REPL verstecken" })

      -- Sendet den aktuellen Code-Block (# %%) als ein einziges Skript an IPython
      vim.keymap.set("n", "<leader>rc", function()
        -- 1. Finde den Start der aktuellen Zelle
        local start_line = vim.fn.search([[^\s*#\s*%%]], "bnW")
        if start_line == 0 then
          start_line = 1
        else
          start_line = start_line + 1 -- Überspringt die # %%-Zeile
        end

        -- 2. Finde das Ende der aktuellen Zelle
        local end_line = vim.fn.search([[^\s*#\s*%%]], "nW")
        if end_line == 0 then
          end_line = vim.fn.line("$")
        else
          end_line = end_line - 1
        end

        -- 3. Hole den gesamten Textblock als Tabelle und übergebe ihn an iron
        if start_line <= end_line then
          local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
          iron.send(nil, lines)
        end
      end, { desc = "Aktuelle Zelle als einzelner Block an IPython senden" })
    '';

    plugins.neo-tree = {
      enable = true;
      settings = {
        window.position = "left";
        filesystem.follow_current_file.enabled = true;
      };
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>n";
        action = "<cmd>Neotree toggle<CR>";
        options.desc = "Toggle Neo-Tree Explorer";
      }
      {
        mode = "n";
        key = "<leader>nf";
        action = "<cmd>Neotree focus<CR>";
        options.desc = "Focus Neo-Tree Explorer";
      }
    ];

    plugins.treesitter = {
      enable = true;
      settings = {
        highlight.enable = true;
        indent.enable = true;
        incremental_selection = {
          enable = true;
          keymaps = {
            init_selection = "<c-space>";
            node_incremental = "<c-space>";
            scope_incremental = "<c-s>";
            node_decremental = "<M-space>";
          };
        };
      };

      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        bash
        c
        html
        javascript
        json
        lua
        markdown
        nix
        python
        rust
        typescript
      ];
    };
  };
}