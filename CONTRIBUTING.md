# Prisidėjimas / Contributing

Ačiū, kad nori padėti! / Thanks for helping!

## Taisyklės / Rules

1. **Jokios BMW programinės įrangos repozitorijoje.** Nekelk `fs0.img`, HmiMain, DSP atvaizdų (`*.bin`)
   ar kitų failų, iškeltų iš automobilio. Dalinkis tik savo įrankių išvestimi (pvz. adresų lentelėmis).
   **No BMW firmware in the repo.** Never commit flash dumps, HmiMain, DSP images or other files copied from a car.
2. **Jokių raktų ar sertifikatų** (`*.key`, `*.pem`, Apple/Google sertifikatai). / **No keys or certificates.**
3. **Niekada nerašyk į `/dev/fs0*`** jokiame skripte. Skriptai, kurie keičia CIC flash, turi būti aiškiai pažymėti
   ir turėti aprašytą atšaukimą. / Never write to `/dev/fs0*`; scripts that modify flash must say so and document an undo.
4. PR'e nurodyk automobilį, CIC programinės įrangos versiją / HmiMain build'ą ir ką išbandei automobilyje.
   In a PR, state your car, CIC software / HmiMain build, and what you tested in the car.
5. Prisidėdamas sutinki, kad tavo indėlis būtų licencijuotas pagal [LICENSE.md](LICENSE.md)
   (PolyForm Noncommercial 1.0.0). / Contributions are licensed under LICENSE.md.

## Kur pradėti / Where to start

Žr. [docs/PLAN.md](docs/PLAN.md). Ypač laukiami: HmiMain profiliai kitiems CIC build'ams, CarPlay adapterio
protokolo įgyvendinimas QNX 6.3 (SH4), DSP vaizdo derinimas.
See docs/PLAN.md. Most wanted: HmiMain profiles for other CIC builds, CarPlay dongle protocol on QNX 6.3 (SH4), DSP video tuning.
