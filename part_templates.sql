-- ============================================================
-- 12. NAKLADALNE LISTE (part_templates) — izhodišče iz Terex katalogov,
-- prebrano 15. 10. 2026. To so DEFAULT sestave; admin jih prilagodi po
-- dejanskem gradbišču (C38/C45/sidra itd. se lahko spreminjajo).
-- Postavke z opombo 'preveri' niso bile zanesljivo razbrane iz kataloga.
-- ============================================================

-- CTT91-GASPER
insert into part_templates (crane_id, part_name, qty, sort_order, notes)
select id, v.part_name, v.qty, v.sort_order, v.notes from cranes,
  (values
    ('Podnožje C38 TS12 F (A+B greda)', 1, 1, null),
    ('Stolpna sekcija TS12 22.12 (11,80 m)', 2, 2, null),
    ('Stolpna sekcija TS12 22.6 (5,90 m)', 1, 3, null),
    ('Vrtljivi del + kabina', 1, 4, null),
    ('Roka — sekcija 5', 1, 5, null),
    ('Roka — sekcija 6', 1, 6, null),
    ('Roka — sekcija 7', 1, 7, null),
    ('Roka — sekcija 8', 1, 8, null),
    ('Roka — sekcija 9', 1, 9, null),
    ('Roka — sekcija 10', 1, 10, null),
    ('Roka — sekcija 11', 1, 11, null),
    ('Roka — sekcija 14', 1, 12, null),
    ('Roka — konica (JIB POINT)', 1, 13, null),
    ('Balast A (3,5 t)', 4, 14, null),
    ('Counter-jip / protiroka — preveri mero, ni eksplicitno v katalogu', 1, 15, null)
  ) as v(part_name, qty, sort_order, notes)
where cranes.code = 'CTT91-GASPER';

-- CTT91-ZOKI
insert into part_templates (crane_id, part_name, qty, sort_order, notes)
select id, v.part_name, v.qty, v.sort_order, v.notes from cranes,
  (values
    ('Podnožje C38 TS12 F (A+B greda)', 1, 1, null),
    ('Stolpna sekcija TS12 22.12 (11,80 m)', 3, 2, null),
    ('Vrtljivi del + kabina', 1, 3, null),
    ('Roka — sekcija 5', 1, 4, null),
    ('Roka — sekcija 6', 1, 5, null),
    ('Roka — sekcija 7', 1, 6, null),
    ('Roka — sekcija 8', 1, 7, null),
    ('Roka — sekcija 9', 1, 8, null),
    ('Roka — sekcija 10', 1, 9, null),
    ('Roka — sekcija 11', 1, 10, null),
    ('Roka — sekcija 14', 1, 11, null),
    ('Roka — konica (JIB POINT)', 1, 12, null),
    ('Balast A (3,5 t)', 4, 13, null),
    ('Counter-jip / protiroka — preveri mero, ni eksplicitno v katalogu', 1, 14, null)
  ) as v(part_name, qty, sort_order, notes)
where cranes.code = 'CTT91-ZOKI';

-- CTT91-LUBO
insert into part_templates (crane_id, part_name, qty, sort_order, notes)
select id, v.part_name, v.qty, v.sort_order, v.notes from cranes,
  (values
    ('Podnožje — sidra (ANCHORS)', 1, 1, '25 m ne obstaja kot standardna postavka v katalogu — preveri pri dobavitelju'),
    ('Stolpna sekcija — preveri točno sestavo', 1, 2, 'glej opombo zgoraj'),
    ('Vrtljivi del + kabina', 1, 3, null),
    ('Roka — sekcija 5', 1, 4, null),
    ('Roka — sekcija 6', 1, 5, null),
    ('Roka — sekcija 7', 1, 6, null),
    ('Roka — konica (JIB POINT)', 1, 7, null),
    ('Balast A (3,5 t)', 1, 8, null),
    ('Balast C (2,3 t)', 3, 9, null),
    ('Counter-jip / protiroka — preveri mero, ni eksplicitno v katalogu', 1, 10, null)
  ) as v(part_name, qty, sort_order, notes)
where cranes.code = 'CTT91-LUBO';

-- CTT91-DONALD
insert into part_templates (crane_id, part_name, qty, sort_order, notes)
select id, v.part_name, v.qty, v.sort_order, v.notes from cranes,
  (values
    ('Podnožje — sidra (ANCHORS) / C58', 1, 1, 'višina 39,85 m potrjena v katalogu (stolp R1), točna sestava sekcij ni bila zanesljivo razbrana — preveri'),
    ('Vrtljivi del + kabina', 1, 2, null),
    ('Roka — sekcija 5', 1, 3, null),
    ('Roka — sekcija 6', 1, 4, null),
    ('Roka — sekcija 7', 1, 5, null),
    ('Roka — sekcija 8', 1, 6, null),
    ('Roka — sekcija 9', 1, 7, null),
    ('Roka — sekcija 10', 1, 8, null),
    ('Roka — sekcija 11', 1, 9, null),
    ('Roka — sekcija 14', 1, 10, null),
    ('Roka — konica (JIB POINT)', 1, 11, null),
    ('Balast A (3,5 t)', 4, 12, null),
    ('Counter-jip / protiroka — preveri mero, ni eksplicitno v katalogu', 1, 13, null)
  ) as v(part_name, qty, sort_order, notes)
where cranes.code = 'CTT91-DONALD';

-- CTT91-SUSHI
insert into part_templates (crane_id, part_name, qty, sort_order, notes)
select id, v.part_name, v.qty, v.sort_order, v.notes from cranes,
  (values
    ('Podnožje — sidra (SIDRA TS12)', 1, 1, 'višina ~34 m (najbližje 33,95 v katalogu), točna sestava sekcij ni bila zanesljivo razbrana — preveri'),
    ('Vrtljivi del + kabina', 1, 2, null),
    ('Roka — sekcija 5', 1, 3, null),
    ('Roka — sekcija 6', 1, 4, null),
    ('Roka — sekcija 7', 1, 5, null),
    ('Roka — sekcija 8', 1, 6, null),
    ('Roka — sekcija 9', 1, 7, null),
    ('Roka — sekcija 10', 1, 8, null),
    ('Roka — konica (JIB POINT)', 1, 9, null),
    ('Balast A (3,5 t)', 2, 10, null),
    ('Balast C (2,3 t)', 3, 11, null),
    ('Counter-jip / protiroka — preveri mero, ni eksplicitno v katalogu', 1, 12, null)
  ) as v(part_name, qty, sort_order, notes)
where cranes.code = 'CTT91-SUSHI';

-- CSE32-SIME
insert into part_templates (crane_id, part_name, qty, sort_order, notes)
select id, v.part_name, v.qty, v.sort_order, v.notes from cranes,
  (values
    ('Žerjav — cela sestavljena enota (samopostavljiv, na lastnem podvozju)', 1, 1, null),
    ('Dopolnilni balast (completion ballast, ločen zabojnik)', 1, 2, 'po potrebi glede na konfiguracijo')
  ) as v(part_name, qty, sort_order, notes)
where cranes.code = 'CSE32-SIME';

-- CSE32-CASPER
insert into part_templates (crane_id, part_name, qty, sort_order, notes)
select id, v.part_name, v.qty, v.sort_order, v.notes from cranes,
  (values
    ('Žerjav — cela sestavljena enota (samopostavljiv, na lastnem podvozju)', 1, 1, null),
    ('Dopolnilni balast (completion ballast, ločen zabojnik)', 1, 2, 'po potrebi glede na konfiguracijo')
  ) as v(part_name, qty, sort_order, notes)
where cranes.code = 'CSE32-CASPER';

-- CSE32-MERCURY
insert into part_templates (crane_id, part_name, qty, sort_order, notes)
select id, v.part_name, v.qty, v.sort_order, v.notes from cranes,
  (values
    ('Žerjav — cela sestavljena enota (samopostavljiv, na lastnem podvozju)', 1, 1, null),
    ('Dopolnilni balast (completion ballast, ločen zabojnik)', 1, 2, 'po potrebi glede na konfiguracijo')
  ) as v(part_name, qty, sort_order, notes)
where cranes.code = 'CSE32-MERCURY';

-- CSE32-COPERNICUS
insert into part_templates (crane_id, part_name, qty, sort_order, notes)
select id, v.part_name, v.qty, v.sort_order, v.notes from cranes,
  (values
    ('Žerjav — cela sestavljena enota (samopostavljiv, na lastnem podvozju)', 1, 1, null),
    ('Dopolnilni balast (completion ballast, ločen zabojnik)', 1, 2, 'po potrebi glede na konfiguracijo')
  ) as v(part_name, qty, sort_order, notes)
where cranes.code = 'CSE32-COPERNICUS';

-- CBR32-LADKO
insert into part_templates (crane_id, part_name, qty, sort_order, notes)
select id, v.part_name, v.qty, v.sort_order, v.notes from cranes,
  (values
    ('Žerjav — cela sestavljena enota (samopostavljiv, na lastnem podvozju)', 1, 1, null),
    ('Dopolnilni balast (completion ballast, ločen zabojnik)', 1, 2, 'po potrebi glede na konfiguracijo')
  ) as v(part_name, qty, sort_order, notes)
where cranes.code = 'CBR32-LADKO';

-- CTT132-JANEZ
insert into part_templates (crane_id, part_name, qty, sort_order, notes)
select id, v.part_name, v.qty, v.sort_order, v.notes from cranes,
  (values
    ('Podnožje C38 TS16 (privzeto — na tabli piše samo "CROSS BASE" brez številke, preveri C38 ali C45)', 1, 1, '30 m → zaokroženo navzgor na 35,65 m (4 sekcije)'),
    ('Stolpna sekcija TS16 22.12 (11,80 m)', 4, 2, null),
    ('Vrtljivi del (SLEWING UNIT + JIB SECTION-35)', 1, 3, null),
    ('Roka — sekcija JIB-36 (koren)', 1, 4, null),
    ('Roka — sekcija 5', 1, 5, null),
    ('Roka — sekcija 6', 1, 6, null),
    ('Roka — sekcija 7', 1, 7, null),
    ('Roka — sekcija 8', 1, 8, null),
    ('Roka — sekcija 9', 1, 9, null),
    ('Roka — sekcija 10', 1, 10, null),
    ('Roka — sekcija 11', 1, 11, null),
    ('Roka — sekcija 14', 1, 12, null),
    ('Roka — konica (JIB POINT)', 1, 13, null),
    ('Balast A (3,5 t)', 5, 14, null),
    ('Balast B (0,8 t)', 5, 15, null),
    ('Counterjib complete (protiroka)', 1, 16, null)
  ) as v(part_name, qty, sort_order, notes)
where cranes.code = 'CTT132-JANEZ';

-- CTT132-MIMI
insert into part_templates (crane_id, part_name, qty, sort_order, notes)
select id, v.part_name, v.qty, v.sort_order, v.notes from cranes,
  (values
    ('Podnožje C45 TS16', 1, 1, null),
    ('Stolpna sekcija TS16 22.6 (5,90 m)', 5, 2, null),
    ('Vrtljivi del (SLEWING UNIT + JIB SECTION-35)', 1, 3, null),
    ('Roka — sekcija JIB-36 (koren)', 1, 4, null),
    ('Roka — sekcija 5', 1, 5, null),
    ('Roka — sekcija 6', 1, 6, null),
    ('Roka — sekcija 7', 1, 7, null),
    ('Roka — sekcija 8', 1, 8, null),
    ('Roka — sekcija 9', 1, 9, null),
    ('Roka — sekcija 10', 1, 10, null),
    ('Roka — konica (JIB POINT)', 1, 11, null),
    ('Balast A (3,5 t)', 5, 12, null),
    ('Balast B (0,8 t)', 4, 13, null),
    ('Counterjib complete (protiroka)', 1, 14, null)
  ) as v(part_name, qty, sort_order, notes)
where cranes.code = 'CTT132-MIMI';

-- CTT472-MIKE
insert into part_templates (crane_id, part_name, qty, sort_order, notes)
select id, v.part_name, v.qty, v.sort_order, v.notes from cranes,
  (values
    ('Podnožje — sidra', 1, 1, 'višina 62,4 m PRESEGA standardne samostoječe izvedbe v katalogu (do 57,5 m) — verjetno sidrano na objekt, obvezno preveri z dobaviteljem'),
    ('Roka — sekcija 31', 1, 2, null),
    ('Roka — sekcija 32', 1, 3, null),
    ('Roka — sekcija 33', 1, 4, null),
    ('Roka — sekcija 34', 1, 5, null),
    ('Roka — sekcija 29', 1, 6, null),
    ('Roka — sekcija 6', 1, 7, null),
    ('Roka — sekcija 7', 1, 8, null),
    ('Roka — sekcija 8', 1, 9, null),
    ('Roka — sekcija 9', 1, 10, null),
    ('Roka — sekcija 10', 1, 11, null),
    ('Roka — sekcija 11', 1, 12, null),
    ('Balast D2 (5,70 t)', 9, 13, null),
    ('Balast TS212', 2, 14, '+4 na drugem mestu — preveri skupno količino'),
    ('Counter-jip / protiroka — preveri mero, ni eksplicitno v katalogu', 1, 15, null)
  ) as v(part_name, qty, sort_order, notes)
where cranes.code = 'CTT472-MIKE';

-- CTT161-MARCOPOLO
insert into part_templates (crane_id, part_name, qty, sort_order, notes)
select id, v.part_name, v.qty, v.sort_order, v.notes from cranes,
  (values
    ('Podnožje C45 TS16', 1, 1, null),
    ('Stolpna sekcija TS16 22.6 (5,90 m)', 7, 2, 'rabi C25 protiutež'),
    ('Vrtljivi del + kabina', 1, 3, null),
    ('Roka — sekcija 4', 1, 4, null),
    ('Roka — sekcija 5', 1, 5, null),
    ('Roka — sekcija 6', 1, 6, null),
    ('Roka — sekcija 7', 1, 7, null),
    ('Roka — sekcija 8', 1, 8, null),
    ('Roka — sekcija 9', 1, 9, null),
    ('Roka — sekcija 10', 1, 10, null),
    ('Roka — sekcija 11', 1, 11, null),
    ('Roka — sekcija 14', 1, 12, null),
    ('Roka — konica (JIB POINT)', 1, 13, null),
    ('Balast A (3,5 t)', 4, 14, null),
    ('Balast B (0,8 t)', 5, 15, null),
    ('Counter-jip / protiroka — preveri mero, ni eksplicitno v katalogu', 1, 16, null)
  ) as v(part_name, qty, sort_order, notes)
where cranes.code = 'CTT161-MARCOPOLO';

-- CTT162-IVETTE
insert into part_templates (crane_id, part_name, qty, sort_order, notes)
select id, v.part_name, v.qty, v.sort_order, v.notes from cranes,
  (values
    ('Podnožje — sidra', 1, 1, 'model na tabli "CTT 162" — v katalogu ne obstaja, obravnavano kot CTT 161A-6 (preveri)'),
    ('Vrtljivi del + kabina', 1, 2, null),
    ('Roka — sekcija 4', 1, 3, null),
    ('Roka — sekcija 5', 1, 4, null),
    ('Roka — sekcija 6', 1, 5, null),
    ('Roka — konica (JIB POINT)', 1, 6, null),
    ('Balast A (3,5 t)', 3, 7, null),
    ('Balast B (0,8 t)', 5, 8, null),
    ('Counter-jip / protiroka — preveri mero, ni eksplicitno v katalogu', 1, 9, null)
  ) as v(part_name, qty, sort_order, notes)
where cranes.code = 'CTT162-IVETTE';

-- CTT162-LADYDIANA
insert into part_templates (crane_id, part_name, qty, sort_order, notes)
select id, v.part_name, v.qty, v.sort_order, v.notes from cranes,
  (values
    ('Podnožje C45 TS16', 1, 1, 'model na tabli "CTT 162" — obravnavano kot CTT 161A-6 (preveri)'),
    ('Stolpna sekcija TS16 22.6 (5,90 m)', 3, 2, null),
    ('Vrtljivi del + kabina', 1, 3, null),
    ('Roka — sekcija 4', 1, 4, null),
    ('Roka — sekcija 5', 1, 5, null),
    ('Roka — sekcija 6', 1, 6, null),
    ('Roka — sekcija 7', 1, 7, null),
    ('Roka — sekcija 8', 1, 8, null),
    ('Roka — sekcija 9', 1, 9, null),
    ('Roka — konica (JIB POINT)', 1, 10, null),
    ('Balast A (3,5 t)', 4, 11, null),
    ('Balast B (0,8 t)', 5, 12, null),
    ('Counter-jip / protiroka — preveri mero, ni eksplicitno v katalogu', 1, 13, null)
  ) as v(part_name, qty, sort_order, notes)
where cranes.code = 'CTT162-LADYDIANA';

-- CTT162-CICIMICI
insert into part_templates (crane_id, part_name, qty, sort_order, notes)
select id, v.part_name, v.qty, v.sort_order, v.notes from cranes,
  (values
    ('Podnožje C45 TS16', 1, 1, 'model na tabli "CTT 162" — obravnavano kot CTT 161A-6 (preveri)'),
    ('Stolpna sekcija TS16 22.6 (5,90 m)', 7, 2, 'rabi C25 protiutež'),
    ('Vrtljivi del + kabina', 1, 3, null),
    ('Roka — sekcija 4', 1, 4, null),
    ('Roka — sekcija 5', 1, 5, null),
    ('Roka — sekcija 6', 1, 6, null),
    ('Roka — sekcija 7', 1, 7, null),
    ('Roka — sekcija 8', 1, 8, null),
    ('Roka — sekcija 9', 1, 9, null),
    ('Roka — sekcija 10', 1, 10, null),
    ('Roka — konica (JIB POINT)', 1, 11, null),
    ('Balast A (3,5 t)', 4, 12, null),
    ('Balast B (0,8 t)', 5, 13, null),
    ('Counter-jip / protiroka — preveri mero, ni eksplicitno v katalogu', 1, 14, null)
  ) as v(part_name, qty, sort_order, notes)
where cranes.code = 'CTT162-CICIMICI';

-- CTT161-SNOOPY
insert into part_templates (crane_id, part_name, qty, sort_order, notes)
select id, v.part_name, v.qty, v.sort_order, v.notes from cranes,
  (values
    ('Žerjav ni sestavljen — samo JIB NO.1 + kabina na skladišču', 1, 1, 'dvoriščni/trenutno nerabljen')
  ) as v(part_name, qty, sort_order, notes)
where cranes.code = 'CTT161-SNOOPY';

-- CTT181-LIONKING
insert into part_templates (crane_id, part_name, qty, sort_order, notes)
select id, v.part_name, v.qty, v.sort_order, v.notes from cranes,
  (values
    ('Podnožje C45 (privzeto — na tabli piše samo "BASE", višina se ujema natančno s C45)', 1, 1, null),
    ('Stolpna sekcija TS21 22.6 (5,90 m)', 4, 2, null),
    ('Vrtljivi del + kabina', 1, 3, null),
    ('Roka — sekcija 22 (koren)', 1, 4, null),
    ('Roka — sekcija 23', 1, 5, null),
    ('Roka — sekcija 24', 1, 6, null),
    ('Roka — sekcija 25', 1, 7, null),
    ('Roka — sekcija 5', 1, 8, null),
    ('Roka — sekcija 6', 1, 9, null),
    ('Roka — sekcija 7', 1, 10, null),
    ('Roka — sekcija 8', 1, 11, null),
    ('Roka — sekcija 9', 1, 12, null),
    ('Balast A (3,5 t)', 5, 13, null),
    ('Balast B (0,8 t)', 3, 14, null),
    ('Counter-jip / protiroka — preveri mero, ni eksplicitno v katalogu', 1, 15, null)
  ) as v(part_name, qty, sort_order, notes)
where cranes.code = 'CTT181-LIONKING';

-- CTT181-TOMJONES
insert into part_templates (crane_id, part_name, qty, sort_order, notes)
select id, v.part_name, v.qty, v.sort_order, v.notes from cranes,
  (values
    ('Podnožje C45 TS21', 1, 1, 'rabi C25 protiutež'),
    ('Stolpna sekcija TS21 22.6 (5,90 m)', 5, 2, null),
    ('Vrtljivi del + kabina', 1, 3, null),
    ('Roka — sekcija 22 (koren)', 1, 4, null),
    ('Roka — sekcija 23', 1, 5, null),
    ('Roka — sekcija 24', 1, 6, null),
    ('Roka — sekcija 25', 1, 7, null),
    ('Roka — sekcija 5', 1, 8, null),
    ('Roka — sekcija 6', 1, 9, null),
    ('Roka — sekcija 7', 1, 10, null),
    ('Roka — sekcija 8', 1, 11, null),
    ('Roka — sekcija 9', 1, 12, null),
    ('Balast A (3,5 t)', 5, 13, null),
    ('Balast B (0,8 t)', 3, 14, null),
    ('Counter-jip / protiroka — preveri mero, ni eksplicitno v katalogu', 1, 15, null)
  ) as v(part_name, qty, sort_order, notes)
where cranes.code = 'CTT181-TOMJONES';

-- CTT181-MYSHARONA
insert into part_templates (crane_id, part_name, qty, sort_order, notes)
select id, v.part_name, v.qty, v.sort_order, v.notes from cranes,
  (values
    ('Podnožje CROSS BASE C50 PEINER', 1, 1, 'NI Terex standardni del, ni v tem katalogu — preveri fizične mere na skladišču'),
    ('Vrtljivi del + kabina', 1, 2, null),
    ('Roka — sekcija 22 (koren)', 1, 3, null),
    ('Roka — sekcija 23', 1, 4, null),
    ('Roka — sekcija 24', 1, 5, null),
    ('Roka — sekcija 25', 1, 6, null),
    ('Roka — sekcija 5', 1, 7, null),
    ('Roka — sekcija 6', 1, 8, null),
    ('Roka — sekcija 7', 1, 9, null),
    ('Roka — sekcija 8', 1, 10, null),
    ('Roka — sekcija 9', 1, 11, null),
    ('Balast A (3,5 t)', 5, 12, null),
    ('Balast B (0,8 t)', 3, 13, null),
    ('Counter-jip / protiroka — preveri mero, ni eksplicitno v katalogu', 1, 14, null)
  ) as v(part_name, qty, sort_order, notes)
where cranes.code = 'CTT181-MYSHARONA';

-- CTT182-ALPHONSE
insert into part_templates (crane_id, part_name, qty, sort_order, notes)
select id, v.part_name, v.qty, v.sort_order, v.notes from cranes,
  (values
    ('Podnožje C45 TS21', 1, 1, 'model na tabli "CTT 182" — v katalogu ne obstaja, obravnavano kot CTT 181B-8 (preveri)'),
    ('Stolpna sekcija TS21 22.6 (5,90 m)', 5, 2, null),
    ('Vrtljivi del + kabina', 1, 3, null),
    ('Roka — sekcija 23 (koren)', 1, 4, null),
    ('Roka — sekcija 24', 1, 5, null),
    ('Roka — sekcija 25', 1, 6, null),
    ('Roka — sekcija 5', 1, 7, null),
    ('Roka — sekcija 6', 1, 8, null),
    ('Balast A (3,5 t)', 4, 9, null),
    ('Balast B (0,8 t)', 2, 10, null),
    ('Counter-jip / protiroka — preveri mero, ni eksplicitno v katalogu', 1, 11, null)
  ) as v(part_name, qty, sort_order, notes)
where cranes.code = 'CTT182-ALPHONSE';

-- CTT182-CALIMERO
insert into part_templates (crane_id, part_name, qty, sort_order, notes)
select id, v.part_name, v.qty, v.sort_order, v.notes from cranes,
  (values
    ('Podnožje C45 TS21', 1, 1, 'model na tabli "CTT 182" — obravnavano kot CTT 181B-8 (preveri); 25m→zaokroženo na 27,00m'),
    ('Stolpna sekcija TS21 22.6 (5,90 m)', 3, 2, null),
    ('Vrtljivi del + kabina', 1, 3, null),
    ('Roka — sekcija 22 (koren)', 1, 4, null),
    ('Roka — sekcija 23', 1, 5, null),
    ('Roka — sekcija 24', 1, 6, null),
    ('Roka — sekcija 25', 1, 7, null),
    ('Roka — sekcija 5', 1, 8, null),
    ('Roka — sekcija 6', 1, 9, null),
    ('Roka — sekcija 7', 1, 10, null),
    ('Roka — sekcija 8', 1, 11, null),
    ('Balast A (3,5 t)', 5, 12, null),
    ('Balast B (0,8 t)', 2, 13, null),
    ('Counter-jip / protiroka — preveri mero, ni eksplicitno v katalogu', 1, 14, null)
  ) as v(part_name, qty, sort_order, notes)
where cranes.code = 'CTT182-CALIMERO';

-- CTT182-RAMBO
insert into part_templates (crane_id, part_name, qty, sort_order, notes)
select id, v.part_name, v.qty, v.sort_order, v.notes from cranes,
  (values
    ('Podnožje C45 TS21', 1, 1, 'model na tabli "CTT 182" — obravnavano kot CTT 181B-8 (preveri); rabi C25 protiutež'),
    ('Stolpna sekcija TS21 22.6 (5,90 m)', 5, 2, null),
    ('Vrtljivi del + kabina', 1, 3, null),
    ('Roka — sekcija 22 (koren)', 1, 4, null),
    ('Roka — sekcija 23', 1, 5, null),
    ('Roka — sekcija 24', 1, 6, null),
    ('Roka — sekcija 25', 1, 7, null),
    ('Roka — sekcija 5', 1, 8, null),
    ('Roka — sekcija 6', 1, 9, null),
    ('Roka — sekcija 7', 1, 10, null),
    ('Roka — sekcija 8', 1, 11, null),
    ('Roka — sekcija 9', 1, 12, null),
    ('Balast A (3,5 t)', 5, 13, null),
    ('Balast B (0,8 t)', 3, 14, null),
    ('Counter-jip / protiroka — preveri mero, ni eksplicitno v katalogu', 1, 15, null)
  ) as v(part_name, qty, sort_order, notes)
where cranes.code = 'CTT182-RAMBO';

-- CTT231-PRINCMUFTI
insert into part_templates (crane_id, part_name, qty, sort_order, notes)
select id, v.part_name, v.qty, v.sort_order, v.notes from cranes,
  (values
    ('Podnožje C60 H20', 1, 1, '56,3m → zaokroženo navzgor na 58,05 m'),
    ('Stolpna sekcija H20 18.4', 11, 2, 'glej opombo: skupno število sekcij do 58,05m, preveri natančno razdelitev'),
    ('Vrtljivi del + kabina', 1, 3, null),
    ('Roka — sekcija 1 (koren)', 1, 4, null),
    ('Roka — sekcija 2', 1, 5, null),
    ('Roka — sekcija 3', 1, 6, null),
    ('Roka — sekcija 4', 1, 7, null),
    ('Roka — sekcija 5', 1, 8, null),
    ('Roka — sekcija 6', 1, 9, null),
    ('Roka — sekcija 7', 1, 10, null),
    ('Balast A (2,37 t)', 4, 11, null),
    ('Balast B (3,2 t)', 2, 12, null),
    ('Counter-jip / protiroka — preveri mero, ni eksplicitno v katalogu', 1, 13, null)
  ) as v(part_name, qty, sort_order, notes)
where cranes.code = 'CTT231-PRINCMUFTI';

-- CTT231-PRINCESSLEIA
insert into part_templates (crane_id, part_name, qty, sort_order, notes)
select id, v.part_name, v.qty, v.sort_order, v.notes from cranes,
  (values
    ('Podnožje C60 H20 (oznaka na tabli "TS25" ni jasna, obravnavano kot C60)', 1, 1, '56,3m → zaokroženo navzgor na 58,05 m'),
    ('Vrtljivi del + kabina', 1, 2, null),
    ('Roka — sekcija 1 (koren)', 1, 3, null),
    ('Roka — sekcija 2', 1, 4, null),
    ('Roka — sekcija 3', 1, 5, null),
    ('Roka — sekcija 4', 1, 6, null),
    ('Roka — sekcija 5', 1, 7, null),
    ('Roka — sekcija 6', 1, 8, null),
    ('Roka — sekcija 7', 1, 9, null),
    ('Roka — sekcija 8', 1, 10, null),
    ('Roka — sekcija 9', 1, 11, null),
    ('Roka — sekcija 10', 1, 12, null),
    ('Roka — sekcija 11', 1, 13, null),
    ('Balast A (2,37 t)', 5, 14, null),
    ('Balast B (3,2 t)', 2, 15, null),
    ('Counter-jip / protiroka — preveri mero, ni eksplicitno v katalogu', 1, 16, null)
  ) as v(part_name, qty, sort_order, notes)
where cranes.code = 'CTT231-PRINCESSLEIA';

-- CTT231-JAMESBOND
insert into part_templates (crane_id, part_name, qty, sort_order, notes)
select id, v.part_name, v.qty, v.sort_order, v.notes from cranes,
  (values
    ('Podnožje C60 H20', 1, 1, '56,3m → zaokroženo navzgor na 58,05 m'),
    ('Vrtljivi del + kabina', 1, 2, null),
    ('Roka — sekcija 1 (koren)', 1, 3, null),
    ('Roka — sekcija 2', 1, 4, null),
    ('Roka — sekcija 3', 1, 5, null),
    ('Roka — sekcija 4', 1, 6, null),
    ('Roka — sekcija 5', 1, 7, null),
    ('Roka — sekcija 6', 1, 8, null),
    ('Roka — sekcija 7', 1, 9, null),
    ('Roka — sekcija 8', 1, 10, null),
    ('Roka — sekcija 9', 1, 11, null),
    ('Roka — sekcija 10', 1, 12, null),
    ('Roka — sekcija 11', 1, 13, null),
    ('Balast A (2,37 t)', 5, 14, null),
    ('Balast B (3,2 t)', 2, 15, null),
    ('Counter-jip / protiroka — preveri mero, ni eksplicitno v katalogu', 1, 16, null)
  ) as v(part_name, qty, sort_order, notes)
where cranes.code = 'CTT231-JAMESBOND';

-- CTT231-RUDA
insert into part_templates (crane_id, part_name, qty, sort_order, notes)
select id, v.part_name, v.qty, v.sort_order, v.notes from cranes,
  (values
    ('Podnožje C60 H20', 1, 1, '45m → zaokroženo navzgor na 46,80 m'),
    ('Vrtljivi del + kabina', 1, 2, null),
    ('Roka — sekcija 1 (koren)', 1, 3, null),
    ('Roka — sekcija 2', 1, 4, null),
    ('Roka — sekcija 3', 1, 5, null),
    ('Roka — sekcija 4', 1, 6, null),
    ('Roka — sekcija 5', 1, 7, null),
    ('Roka — sekcija 6', 1, 8, null),
    ('Roka — sekcija 7', 1, 9, null),
    ('Roka — sekcija 8', 1, 10, null),
    ('Roka — sekcija 9', 1, 11, null),
    ('Roka — sekcija 10', 1, 12, null),
    ('Balast A (2,37 t)', 5, 13, null),
    ('Balast B (3,2 t)', 2, 14, null),
    ('Counter-jip / protiroka — preveri mero, ni eksplicitno v katalogu', 1, 15, null)
  ) as v(part_name, qty, sort_order, notes)
where cranes.code = 'CTT231-RUDA';

-- CTT231-TITO
insert into part_templates (crane_id, part_name, qty, sort_order, notes)
select id, v.part_name, v.qty, v.sort_order, v.notes from cranes,
  (values
    ('Podnožje C60 H20', 1, 1, '44,5m → zaokroženo navzgor na 46,80 m'),
    ('Vrtljivi del + kabina', 1, 2, null),
    ('Roka — sekcija 1 (koren)', 1, 3, null),
    ('Roka — sekcija 2', 1, 4, null),
    ('Roka — sekcija 3', 1, 5, null),
    ('Roka — sekcija 4', 1, 6, null),
    ('Roka — sekcija 5', 1, 7, null),
    ('Roka — sekcija 6', 1, 8, null),
    ('Roka — sekcija 7', 1, 9, null),
    ('Roka — sekcija 8', 1, 10, null),
    ('Roka — sekcija 9', 1, 11, null),
    ('Roka — sekcija 10', 1, 12, null),
    ('Balast A (2,37 t)', 5, 13, null),
    ('Balast B (3,2 t)', 2, 14, null),
    ('Counter-jip / protiroka — preveri mero, ni eksplicitno v katalogu', 1, 15, null)
  ) as v(part_name, qty, sort_order, notes)
where cranes.code = 'CTT231-TITO';

-- CTT231-MRNICE
insert into part_templates (crane_id, part_name, qty, sort_order, notes)
select id, v.part_name, v.qty, v.sort_order, v.notes from cranes,
  (values
    ('Dvoriščni žerjav — ni sestavljen, samo JIB NO.1 + kabina', 1, 1, 'YARD CRANE, ne gre v najem')
  ) as v(part_name, qty, sort_order, notes)
where cranes.code = 'CTT231-MRNICE';

-- CTT152-CAFFEREN
insert into part_templates (crane_id, part_name, qty, sort_order, notes)
select id, v.part_name, v.qty, v.sort_order, v.notes from cranes,
  (values
    ('Podnožje C38 TS16 F', 1, 1, '44,50 m — rabi C25 protiutež; potrjuje ročni popravek na tabli (44,5, ne 45)'),
    ('Stolpna sekcija TS16 22.6 (5,90 m)', 7, 2, null),
    ('Vrtljivi del + kabina', 1, 3, null),
    ('Roka — sekcija 50 (koren)', 1, 4, null),
    ('Roka — sekcija 51', 1, 5, null),
    ('Roka — sekcija 52', 1, 6, null),
    ('Roka — sekcija 5', 1, 7, null),
    ('Roka — sekcija 6', 1, 8, null),
    ('Roka — sekcija 7', 1, 9, null),
    ('Roka — sekcija 8', 1, 10, null),
    ('Roka — sekcija 9', 1, 11, null),
    ('Balast A (3,5 t)', 5, 12, null),
    ('Balast AB (1,75 t)', 1, 13, null),
    ('Counter-jip / protiroka — preveri mero, ni eksplicitno v katalogu', 1, 14, null)
  ) as v(part_name, qty, sort_order, notes)
where cranes.code = 'CTT152-CAFFEREN';

-- CTT332-KINGCHARLES
insert into part_templates (crane_id, part_name, qty, sort_order, notes)
select id, v.part_name, v.qty, v.sort_order, v.notes from cranes,
  (values
    ('Podnožje — sidra (ANCHORS)', 1, 1, '20m ≈ 19,95m (zelo blizu standardne postavke)'),
    ('Stolpna sekcija H20 18.4', 2, 2, null),
    ('Vrtljivi del + kabina', 1, 3, null),
    ('Roka — sekcija 17 (koren)', 1, 4, null),
    ('Roka — sekcija 13', 1, 5, null),
    ('Roka — sekcija 14', 1, 6, null),
    ('Roka — sekcija 15', 1, 7, null),
    ('Roka — sekcija 16', 1, 8, null),
    ('Balast C (3,00 t)', 6, 9, null),
    ('Counter-jip / protiroka — preveri mero, ni eksplicitno v katalogu', 1, 10, null)
  ) as v(part_name, qty, sort_order, notes)
where cranes.code = 'CTT332-KINGCHARLES';
