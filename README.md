# TS-Restockplus
A tool to generate a Tweakscale file by parsing Restockplus parts including rigid legs.
Also works with the NearFuture Solar Mod.

General idea :
- Parse parts of an AddOn named SOURCEADDON
- Produce a cfg file with a TweakScale, SOURCEADDON dependancy named SOURCEADDON_Tweakscale.cfg
- This file is intended to be part of a TweakScaleCompanion_SOURCEADDON new AddOn 


The tool is currently being designed in the dev branch so that it could be
- more flexible
- can handle properly FOR and NEEDS statements of TweakScale 2.5
- better at finding the scaling method for some parts (solar panels with a size, mostly)
- compliant with the "Companion" AddOn design like TweakScaleCompanion_NFS made by Lisias https://github.com/net-lisias-ksp/TweakScaleCompanion_NFS
