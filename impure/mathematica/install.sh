#!/usr/bin/env bash

nix-env --install --file default.nix


echo -e "\nMathematica is now installed!"
echo -e "\nIf mathematica does not open try setting the following environment variable:"
echo -e ">   QT_XCB_GL_INTEGRATION=none"
