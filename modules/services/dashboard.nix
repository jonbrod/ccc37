# dashboard.nix
# Einfache Startseite auf Port 80 nur über Tailscale
{ host, pkgs, ... }:

let
  vars = import ../../hosts/${host}/vars.nix;

  indexHtml = pkgs.writeText "index.html" ''
    <!doctype html>
    <html lang="de">
    <head>
      <meta charset="utf-8" />
      <meta name="viewport" content="width=device-width, initial-scale=1" />
      <title>ccc37 – Dienste</title>
      <style>
        body {
          font-family: system-ui, -apple-system, sans-serif;
          background: #111318;
          color: #eef1f6;
          margin: 0;
          padding: 2rem;
        }
        main {
          max-width: 720px;
          margin: 0 auto;
        }
        h1 {
          font-size: 1.5rem;
          margin-bottom: 1.5rem;
        }
        .grid {
          display: grid;
          grid-template-columns: repeat(auto-fit, minmax(210px, 1fr));
          gap: 1rem;
        }
        a.card {
          display: block;
          padding: 1rem 1.2rem;
          border-radius: 10px;
          background: #1b1f27;
          border: 1px solid #2c3240;
          color: inherit;
          text-decoration: none;
        }
        a.card:hover {
          border-color: #6ea8fe;
        }
        .title {
          font-weight: 600;
          font-size: 1.05rem;
        }
        .url {
          margin-top: 0.35rem;
          font-size: 0.9rem;
          color: #9aa4b2;
        }
      </style>
    </head>
    <body>
      <main>
        <h1>Dienste auf ${vars.tsHost}</h1>
        <div class="grid">
          <a class="card" href="http://ccc37:8000" target="_blank" rel="noopener">
            <div class="title">Nextcloud</div>
            <div class="url">ccc37:8000</div>
          </a>
          <a class="card" href="http://ccc37:3000" target="_blank" rel="noopener">
            <div class="title">Grafana</div>
            <div class="url">ccc37:3000</div>
          </a>
          <a class="card" href="http://ccc37:8123" target="_blank" rel="noopener">
            <div class="title">Home Assistant</div>
            <div class="url">ccc37:8123</div>
          </a>
          <a class="card" href="http://ccc37:8080" target="_blank" rel="noopener">
            <div class="title">Zigbee2MQTT</div>
            <div class="url">ccc37:8080</div>
          </a>
        </div>
      </main>
    </body>
    </html>
  '';
in
{
  services.nginx = {
    enable = true;
    virtualHosts."ccc37-dashboard" = {
      listen = [
        { addr = "0.0.0.0"; port = 80; ssl = false; }
      ];
      locations."/" = {
        return = "200 ${builtins.toJSON (builtins.readFile indexHtml)}";
        extraConfig = ''
          default_type text/html;
        '';
      };
    };
  };

  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 80 ];
}
