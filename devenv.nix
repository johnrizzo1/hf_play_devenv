{ pkgs, lib, config, inputs, ... }:
let
  mypkgs = import inputs.nixpkgs {
    inherit (pkgs.stdenv) system;

    config.allowUnfree = true;
    config.cudaSupport = true;
  };
in 
{
  packages = with mypkgs; [
    git
    cudatoolkit
    portaudio
    (python3.withPackages (python-pkgs: with python-pkgs; [
      accelerate
      diffusers
      jupyter-all
      jupyter-server
      jupyter-server-mathjax
      ipykernel
      ipywidgets
      pandas
      pyaudio
      requests
      torch
      torchaudio
      torchvision
      transformers
    ]))
  ];

  enterShell = ''
    git --version
    python -c 'import torch; print(f"Cuda Enabled: {torch.cuda.is_available()}")'
    # python -c 'import torch; print(torch.mps.is_available())'
  '';

  languages.python = {
    enable = true;
    uv.enable = true;
    # venv.enable = true;
    # venv.requirements = ''''; # Last resort.  Use Packages first.
  };
  # See full reference at https://devenv.sh/reference/options/
}
