# Contributing

Thanks for helping!

## Rules

1. **No BMW software in the repo.** Never commit flash dumps (`fs0.img`), HmiMain, DSP images (`*.bin`) or any other
   file copied from a car. Share only the output of our tools (for example address tables).
2. **No keys or certificates** (`*.key`, `*.pem`, Apple/Google certificates).
3. **Never write to `/dev/fs0*`** in any script. Scripts that modify the CIC flash must say so clearly and document an undo.
4. In a PR, state your car, CIC software version / HmiMain build, and what you tested in the car.
5. By contributing you agree that your contribution is licensed under [LICENSE.md](LICENSE.md)
   (PolyForm Noncommercial 1.0.0).

## Testers with their own car

Owners of a CIC HIGH car are as valuable as developers, ideally with a Combox (Bluetooth audio and calls must
keep working next to CarPlay). Start with the read-only diagnostic stick (see README) and open a
[Car report](../../issues/new?template=car-report.yml) issue.

## Where to start

See [docs/PLAN.md](docs/PLAN.md). Most wanted: HmiMain profiles for other CIC builds, the CarPlay dongle protocol
on QNX 6.3 (SH4), and DSP video tuning.
