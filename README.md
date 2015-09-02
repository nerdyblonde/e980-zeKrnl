# e980-zeKrnl

## About...

Hello,

This is a port of Cyanogen's lge-kernel-gproj for one and only - LG 
Optimus G Pro. It supports all E98x variants, and I don't have a plan 
to support F240x variants for sake of reasons - first of all, I don't 
have that device, second - I don't know anything about it, so far it 
was proven that F240x is different for more than modem.

Currenlty supported Android version is 4.4, which mean all CM11.0 
based ROMs will support it. I myself I'm using it on PAC 4.4.

## Branching and versioning
Since I'm too lazy to write another README for every branch I have:

- **master** branch is used as a starting point. Highly stable, but will not be updated after v1.3
- **kk-stable** is main stable branch. This is the one you want to build from, and this one will be updated.
- **caf/LA.AF.1.1_rb1.18** and **e980-kk-LA.AF** are pure CAF msm8960/apq8064 code, so don't try to do anything with them.
- **lp-testing** and **kk-dev** are main development branches; you may try to build something, but there is no warranty it will work.
- random branches with exp, experimental,danger,whoa etc. in names - don't touch, or kittens will die.

Current STABLE version is tagged as v1.3. Ignore the fact that there is no version 1.2.

## Progress

Current version is **v1.3**.

- [x] CPU Governors
	- [x] Intellidemand
	- [x] Intelliactive
	- [x] DanceDance
	- [x] Wheatley
	- [x] Lionheart
	- [x] SmartassV2
	- [x] Adaptive
- [x] Thermal control
	- [x] Thermald
	- [x] Intellithermal
	- [x] Core control
- [x] IO Schedulers
	- [x] SIO
	- [x] VR
	- [x] ZEN
- [x] TCP Congestion Algorhitm
	- [x] cubic
	- [x] reno
	- [x] westwood
	- [x] highspeed
	- [x] hybla
	- [x] htcp
	- [x] vegas
	- [x] veno
	- [x] scalable
	- [x] lp
	- [x] yeah
	- [x] illinois
- [x] CPU input boost [in kk-dev]
- [x] Stock (LG) camera driver [in kk-dev]
- [x] Faux sound
- [x] Fast charge
- [x] exFAT support [in code, needs more patching]
- [x] Voltage control [in kk-dev]
- [ ] CPU overclocking
- [ ] GPU overclocking
- [x] Double tap to wake
- [x] Sweep2Wake & Sweep2Sleep
- [ ] Update to newer kernel-3.4 repos [trying to figure out how]
- [x] Support for Lollipop (CM12.x) [in testing] and later Android M [are you kidding me, it isn't even released yet]
- [ ] Additional tweaks and features -> feel free to ask & request
