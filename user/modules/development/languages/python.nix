{ pkgs, lib, config, ... }:
let
    cfg = config.lang.python;

    jupyter-vscode = rec {
        name = "Jupyter-VSCode";
        exec = "jupyter-vscode";

        configDir = ".config/${name}";
        settings = {
            "editor.fontFamily" = "Fira Code";
            "editor.fontLigatures" = true;
            "editor.fontSize" = 14;
            "editor.formatOnSave" = true;
            "editor.renderWhitespace" = "all";
            "editor.tabSize" = 4;
            "editor.wordWrap" = "on";

            "files.autoSave" = "onWindowChange";
            "files.autoSaveDelay" = 1000;
            "files.insertFinalNewline" = true;
            "files.trimTrailingWhitespace" = true;

            "keyboard.dispatch" = "keyCode";

            "workbench.colorTheme" = "Lushay";
            "workbench.iconTheme" = "vscode-icons";
            "workbench.startupEditor" = "newUntitledFile";

            "terminal.integrated.shell.linux" = "pkgs.bash/bin/bash";
            "terminal.integrated.hideOnStartup" = "whenEmpty";
            "security.workspace.trust.StartupPrompt" = "never";

            # Setup Neovim for vscode-neovim extension
            "vscode-neovim.neovimExecutablePaths.linux" = pkgs.neovim + "/bin/nvim";
            "vscode-neovim.neovimInitVimPaths.linux" = pkgs.writeText "init.vim" "";

            # VSCode told me to do this
            "extensions.experimental.affinity" = {
                "asvetliakov.vscode-neovim" = 1;
            };
        };

        keybinds = [
            {
                "key" = "ctrl+enter";
                "command" = "notebook.cell.quitEdit";
                "when" = "inputFocus && notebookEditorFocused && !inlineChatFocused && notebookCellType == 'markup'";
            }
            {
                "key" = "ctrl+enter";
                "command" = "notebook.cell.execute";
                "when" = "notebookCellListFocused && notebookMissingKernelExtension && !notebookCellExecuting && notebookCellType == 'code' || !notebookCellExecuting && notebookCellType == 'code' && notebookCellListFocused || inlineChatFocused && notebookCellChatFocused && notebookKernelCount > 0 || !notebookCellExecuting && notebookCellType == 'code' && notebookCellListFocused || inlineChatFocused && notebookCellChatFocused && notebookKernelSourceCount > 0 || inlineChatFocused && notebookCellChatFocused && notebookMissingKernelExtension && !notebookCellExecuting && notebookCellType == 'code'";
            }
        ];

        package = let

        codium = pkgs.writeShellScript name ''
            ${(pkgs.vscode-with-extensions.override {
                vscode = pkgs.vscodium;
                vscodeExtensions = with pkgs.vscode-extensions; [
                    ms-python.python
                    ms-toolsai.jupyter
                    asvetliakov.vscode-neovim
                    tomoki1207.pdf
                ];
            })}/bin/codium --user-data-dir ~/${configDir} $@
        '';

        desktopItem = pkgs.makeDesktopItem {
            name = name;
            exec = exec;
            desktopName = name;
            comment = "VSCode with Jupyter support";
            type = "Application";
            categories = [];
            icon = "jupyter";
            terminal = false;
            startupWMClass = name;
        };

        in
        pkgs.stdenv.mkDerivation {
            pname = name;
            name = exec;

            phases = [ "installPhase" ];

            installPhase = ''

                # Install executable
                mkdir -p $out/bin
                ln -s ${codium} $out/bin/${name}
                ln -s ${codium} $out/bin/jcode

                # Install desktop item
                mkdir -p $out/share/applications
                install -Dm444 -t $out/share/applications ${desktopItem}/share/applications/*

                '';
        };
    };

in
{

    options.lang.python = {
        enable = lib.mkEnableOption "Python language support";
        notebooks = lib.mkEnableOption "Jupyter notebooks";
    };

    config = lib.mkIf cfg.enable {
        home.packages = with pkgs; [
            (python3.withPackages (python-pkgs: with python-pkgs; [
                  # select Python packages here
                  pandas
                  requests
                  numpy
                  matplotlib
                  bpython
            ] ++ (if cfg.notebooks then [ jupyter ] else [])
            ))
        ] ++ (if cfg.notebooks then [ jupyter-vscode.package ] else []);

        home.file."${jupyter-vscode.configDir}/User/settings.json".text = builtins.toJSON jupyter-vscode.settings;

        home.file."${jupyter-vscode.configDir}/User/keybindings.json".text = builtins.toJSON jupyter-vscode.keybinds;
    };
}
