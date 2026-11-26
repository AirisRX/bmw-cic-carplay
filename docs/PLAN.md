# Planas: laidinis CarPlay BMW CIC HIGH

Atnaujinta 2026-11-26.

## Tyrimo santrauka

- **Grynai programinio CarPlay CIC sistemai viešai nėra.** CarPlay reikalauja Apple MFi autentifikacijos lusto,
  be to, laidinio CarPlay metu iPhone tampa USB „host“, o CIC USB prievadas veikia tik kaip host.
  Visi rasti CarPlay CIC pasiūlymai yra aparatinės dėžutės, kurios vaizdą įterpia per LVDS (pvz. Bimmertech MMI Prime).
- **Programinis Android Auto CIC sistemai egzistuoja:** [bmw-cic-androidauto](https://github.com/josemalm32/bmw-cic-androidauto) (AAPlugin).
  - Veikia CIC HmiMain viduje, H.264/AAC dekoduoja CIC DSP (TI DM642), valdymas per iDrive.
  - Diegiamas per USB: CIC paleidimo metu vykdo užkoduotą `/fs/usb0/copie_scr.sh`.
  - Žinomi HmiMain build'ai: 9283417A (C1A, E9x), `CIC_L6_1107_Release B1107-501-1121A Build 11` (**E60 LCI**),
    `CIC_L6_1103_Release B1103-500-1048A Build 43` (C16A, E9x LCI). Kitus galima profiliuoti iš `/dev/fs0` kopijos.
  - Ribos: 800x480 vaizdas (DSP riba), ~0,5 s vėlavimas, nėra mikrofono.
- **CarPlay adapteriai (Carlinkit CPC200 ir pan.)** patys atlieka CarPlay ir MFi dalį, o USB host'ui siunčia H.264 vaizdą
  ir garsą paprastu protokolu. Jis aprašytas atviruose projektuose (node-carplay, pi-carplay). Adapteris turi savo Wi-Fi,
  todėl gali veikti ir belaidis CarPlay.

## Architektūra

```
iPhone --(laidu arba Wi-Fi)--> CarPlay adapteris --USB--> CIC
                                                         ├─ įskiepis HmiMain'e (meniu, iDrive klavišai)
                                                         ├─ USB protokolo procesas (adapterio protokolas vietoj AA)
                                                         └─ DSP maitintojas (H.264 + AAC/PCM -> DM642)
```

Iš AAPlugin perimama: HMI įskiepis, DSP vaizdo/garso kelias, iDrive klavišų perėmimas.
Pakeičiama: Android Auto protokolas (AOA + TLS) -> CarPlay adapterio protokolas.

## Etapai

1. **CIC versijos nustatymas** (dabar). Diagnostinis USB (`diag/`) nuskaito sistemos info ir `/dev/fs0` kopiją.
   Iš jos ištraukiamas HmiMain ir nustatoma, ar jis sutampa su žinomu profiliu (tikėtina E60 LCI build).
2. **Įrankių grandinė.** QNX Momentics 6.3.x (SH4, `ntosh-gcc-3.3.5`) Windows kompiuteryje. QNX ją jau nurašė,
   reikia myQNX paskyros arba archyvinės kopijos. Sunkiausia vieta.
3. **Bazinis testas.** Su nekeistu AAPlugin (Android telefonas, jei įmanoma pasiskolinti) patikrinti, kad vaizdas per DSP
   veikia tavo CIC. Tai įrodo DSP kelią prieš rašant CarPlay dalį.
4. **Adapterio protokolas QNX'e.** Perrašyti `libcicaa` USB dalį adapterio protokolui. Pirma testuojama kompiuteryje
   (Linux + adapteris), tik paskui CIC.
5. **Vaizdo derinimas.** Paprašyti adapterio 800x480 H.264 Baseline, patikrinti DSP apkrovą.
6. **Garsas ir valdymas.** Adapterio garsas (PCM/AAC) į DSP, iDrive pasukimas/paspaudimas -> CarPlay mygtukai.

## Rizikos

- Diagnostika (1 etapas) į CIC nieko nerašo.
- Įskiepis rašomas į flash `Plugins/` aplanką. Pašalinamas ištrynus aplanką. DSP pakeitimas laikomas tik RAM.
- **Neatnaujinti CIC programinės įrangos** (ISTA/E-Sys) vien dėl šio projekto: tai didžiausia sugadinimo rizika.
- Niekada nerašyti į `/dev/fs0*`.

## Reikalinga

- FAT32 USB atmintukas (≥1 GB).
- CarPlay USB adapteris (Carlinkit CPC200 tipo), pirkti po 1 etapo.
- Windows kompiuteris QNX įrankiams.
