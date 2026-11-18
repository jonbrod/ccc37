{
	pkgs, 
	...
}: let
	yazi-plugins = pkgs.fetchFromGitHub {
		owner = "yazi-rs";
		repo = "plugins";
		rev = "603fa36d554750a827bbdb3b4d5f779c5b066c38";
		hash = "sha256-DfcN2VU+8iQazgT9MXm2dj7742W5fhScSm1FEkd/5Tk=";
	};
in {
  home.packages = with pkgs; [
		yazi
		nerd-fonts.jetbrains-mono
		ffmpeg
		unar
		p7zip
		jq
		poppler masterpdfeditor
		fd
		ripgrep
		fzf
		zoxide
		resvg
		imagemagick
		wl-clipboard
  ];
	programs.yazi = {
		enable = true;
		enableZshIntegration = true;
		shellWrapperName = "y";

		settings = {
			opener = {
				edit = [
					{
						run = ''nvim "$a"''; 
						block = true;
						for = "unix";
						desc = "Open in Neovim";
					}
				];
			};
			mgr = {
				preview = "max";
				previewOnHover = true;
				previewOnHoverDelay = 500;
			};
			preview = {
				max_width = 1000;
				max_height = 1000;
			};
		};

		plugins = {
			chmod = "${yazi-plugins}/chmod.yazi";
			full-border = "${yazi-plugins}/full-border.yazi";
			toggle-pane = "${yazi-plugins}/toggle-pane.yazi";
			starship = pkgs.fetchFromGitHub {
				owner = "Rolv-Apneseth";
				repo = "starship.yazi";
				rev = "ea92cf49380466f07231c952b409831e6afd2156";
				sha256 = "sha256-Jvoc/7YaOOppu8K2lJaVgiuBIyanRHHjEA6ZvnrFtiQ=";
			};
		};

		initLua = ''
			require("full-border"):setup()
			require("starship"):setup()
		'';

		keymap = {
			mgr.prepend_keymap = [
				{
					on = "T";
					run = "plugin toggle-pane max-preview";
					desc = "Maximize or restore the preview pane";
				}
				{
					on = ["c" "m"];
					run = "plugin chmod";
					desc = "Chmod on selected files";
				}
			];
		};
	};
}