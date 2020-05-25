#!/bin/bash

opam init
eval $(opam env)
opam switch create 4.10.0
eval $(opam env)
opam install mirage
