# Dev Flakes ❄️
A personal collection of Nix flakes defining development environments for non-nix projects, typically at work.

## Usage
In a sub-shell:
```nix
nix develop /path/to/dev-flakes/<project>
```

In `.envrc` for use with [direnv](https://github.com/direnv/direnv) (and likely [nix-direnv](https://github.com/nix-community/nix-direnv)):
```
use flake /path/to/dev-flakes/<project>
```

## Guiding principles
### These flakes/development environments should:
- Provide the main tools to build/run/test a project on a minimal system like NixOS
- Be independent enough to be adopted in the mainline project

### These flakes/development environments should not:
- Replicate projects' existing version pinning
    - e.g. a Python project's `requirements.txt` should be respected, even if that means installing dependencies through `pip`
- Provide dependency services that are not themselves being _developed_, e.g. databases
    - Services can cause conflicts between projects, e.g. two services trying to run on the same port
    - IMO such services are better served by containerization or single system-level services
- Define anything too user-specific
    - Editors, environment variables, etc. should be managed elsewhere through home-manager, direnv, nix overlays, etc.
- Define environments for [untested architectures](https://discourse.nixos.org/t/what-are-reasons-to-not-use-flake-utils/21140/2)
