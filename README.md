# bmw-cic-carplay

Laidinis Apple CarPlay BMW **CIC HIGH** iDrive sistemai (tikslinis automobilis: E61 LCI 2009, CIC High + Combox).
Idėja: CarPlay USB adapteris (Carlinkit tipo) atlieka Apple dalį ir per USB atiduoda H.264 vaizdą ir garsą,
o CIC viduje veikiantis įskiepis vaizdą dekoduoja CIC DSP (TI DM642) ir rodo ekrane, valdymas per iDrive.

Statusas: **1 etapas, CIC versijos nustatymas.** Plačiau: [docs/PLAN.md](docs/PLAN.md).

## Struktūra

| Kelias | Kas tai |
|---|---|
| `diag/copie_scr.plain.sh` | Diagnostinis skriptas (tik skaitymas): CIC info + flash kopija į USB atmintuką |
| `tools/cic_script.py` | CIC `copie_scr.sh` kodavimas/dekodavimas ir USB paruošimas |
| `docs/PLAN.md` | Tyrimo santrauka, rizikos ir etapų planas |

## Diagnostinio USB paruošimas

```
python tools/cic_script.py stage diag/copie_scr.plain.sh out/usb
```

`out/usb/copie_scr.sh` nukopijuok į FAT32 atmintuko šaknį, įjunk degimą, įkišk atmintuką ir perkrauk CIC
(laikyk radijo įjungimo/garso rankenėlę ~25–30 s). Po ~5 min atmintuke bus `CICDIAG/` su `INFO.TXT`, `fs0.img`, `DONE.TXT`.

**`fs0.img` ir kitų automobilio iškeltinių failų į repozitoriją nekelk** (`.gitignore` juos blokuoja).

## Pastaba dėl licencijų

Remiamės viešai aprašytu [bmw-cic-androidauto](https://github.com/josemalm32/bmw-cic-androidauto) projektu
(PolyForm Noncommercial 1.0.0). Jo kodą naudoti galima tik nekomerciškai; šis projektas asmeniniam naudojimui.
