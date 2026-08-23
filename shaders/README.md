# Shader Effects

This directory contains shader effects written in Lua using moonshine library.

Raw shader GLSL files must be placed under assets/shaders.

Always have postWorld.lua and postWorld.lua in this directory.

`postAll` is applied for the entire frame, while `postWorld` is applied only to the world rendering.

The order of shader effects matter in both `postAll` and `postWorld`.
