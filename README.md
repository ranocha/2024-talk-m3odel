# Adaptive Numerical Methods for Continuum Models

[![License: MIT](https://img.shields.io/badge/License-MIT-success.svg)](https://opensource.org/licenses/MIT)

This repository contains the source code for the hands-on introduction
to adaptive meshes with [T8code.jl](https://github.com/DLR-AMR/T8code.jl)
given by Hendrik Ranocha at the
[M3ODEL Lunch Talk Seminar](https://model.uni-mainz.de/lunch-talks/)
on March 28, 2024.

You can also preview a
[static version of the demo](https://ranocha.de/2024-talk-m3odel/t8code_demo.html).


## Reproducibility

To reproduce the live demo of [T8code.jl](https://github.com/DLR-AMR/T8code.jl)
shown in the talk, perform the following steps:

### Install Julia

Go to https://julialang.org/downloads and download the latest stable version of Julia
(this repository was created with Julia v1.10.2).

### Get reproducibility repository

Clone this reproducibility repository by executing
```shell
git clone https://github.com/sloede/talk-2024-dlr-braunschweig-repro.git
```

### Start Julia and run code

Go to the cloned repository and start the Julia REPL with

```bash
julia --project=. -e 'import Pkg; Pkg.instantiate(); import Pluto; Pluto.run()'
```

This will start [Pluto.jl](https://github.com/fonsp/Pluto.jl). Open the Pluto
notebook `t8code_demo.jl`.


## Authors

- [Hendrik Ranocha](https://ranocha.de) (Johannes Gutenberg University Mainz, Germany)


## Disclaimer

Everything is provided as is and without warranty. Use at your own risk!
