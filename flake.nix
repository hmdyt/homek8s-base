{
  description = "homek8s - Home Kubernetes Infrastructure";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            kubernetes-helm
            k9s
            kubectl
            kubeseal
            opentofu
            argocd
          ];

          shellHook = ''
            export KUBECONFIG="$PWD/k3s.yaml"

            if [ -f .env ]; then
              set -a
              source .env
              set +a
            fi

            export PATH="$PWD/scripts:$PATH"
            export ARGOCD_OPTS="--core"

            kubectl config set-context --current --namespace=argocd >/dev/null 2>&1
          '';
        };
      }
    );
}
