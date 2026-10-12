# STK Adria — Koledar žerjavov

Ena datoteka (`index.html`) — koledar + naklad/razklad. Deluje tudi brez nastavitve
(DEMO način z vzorčnimi podatki), da lahko takoj preizkusiš vmesnik.

## 1. Supabase (baza + prijave)

1. Pojdi na [supabase.com](https://supabase.com) → **New project**.
2. Ko je projekt ustvarjen: **SQL Editor → New query**, prilepi **celotno** vsebino
   datoteke [`schema.sql`](schema.sql) in poženi (Run). To ustvari vse tabele, pravila
   dostopa in samodejno povezavo koledar → naklad/razklad.
3. **Authentication → Users → Invite user** — povabi vsakega člana ekipe (vsak dobi
   e-mail s povezavo, kjer si sam nastavi geslo). Vključno s tremi admini:
   Marjetka Podbregar, Vladimir Podbregar, Robert Travner.
4. Ko se je vsak od treh adminov vsaj enkrat prijavil (s čimer se ustvari vrstica v
   `profiles`), pojdi nazaj v **SQL Editor** in poženi:
   ```sql
   update profiles set role = 'admin' where email in (
     'marjetka@...', 'vladimir@...', 'robert@...'
   );
   ```
   (vse ostale povabljene osebe ostanejo `role = 'viewer'` — vidijo koledar in
   naklad/razklad, ne morejo pa urejati koledarja ali žerjavov).
5. **Settings → API** — skopiraj **Project URL** in **anon public key** (NE service
   role key) in ju vstavi na vrh `index.html`:
   ```js
   const SUPABASE_URL = 'https://xxxxx.supabase.co';
   const SUPABASE_ANON_KEY = 'eyJ...';
   ```
   Ko ti dve vrstici nista več privzeti, se DEMO banner izklopi in stran dela z živo bazo.

## 2. Vnos žerjavov in nakladalnih list

Lahko ročno prek **Uprava → Žerjavi** (ko si prijavljen kot admin) — ali mi pošlji
seznam vseh 38 žerjavov (šifra, ime, model, višina, dolžina roke) in nakladalne liste
zanje, pa pripravim SQL `insert` stavke za vse naenkrat.

## 3. Objava na GitHub Pages

1. Ustvari prazen repozitorij na github.com (brez README, brez .gitignore).
2. Naloži vanj `index.html` (lahko kar prek **Add file → Upload files** v brskalniku).
3. **Settings → Pages** → Source: `main`, mapa `/ (root)` → Save.
4. Stran bo živa na `https://<tvoj-github-username>.github.io/<ime-repozitorija>/`.

## Kako deluje samodejna povezava koledar → naklad/razklad

- Admin v koledarju doda dogodek tipa **Naklad** za nek žerjav → sistem takoj ustvari
  "nalaganje" s checklist seznamom vseh delov iz nakladalne liste tega žerjava
  (urejene v Uprava → Žerjavi → Lista).
- Admin doda dogodek tipa **Razklad** za isti žerjav → sistem samodejno povzame
  **isti seznam delov**, ki je šel na zadnji naklad tega žerjava — to je checklist
  "kar moramo dobiti nazaj".
- Kdorkoli je prijavljen, lahko obkljuka dele, ko prispejo/odidejo.
- Admin lahko del označi **"Šlo drugam"** z opombo (npr. šlo je neposredno na drugo
  gradbišče) — ta del se izloči iz "manjka" opozoril, opomba pa se **samodejno prikaže**
  na naslednjem nalaganju/razkladanju istega žerjava, dokler je admin ne označi za rešeno.
- Ko admin **zaključi razklad**, se za vsak del, ki ni bil obkljukan niti označen
  "šlo drugam", samodejno ustvari opozorilo v zavihku **Opozorila**.

## Lokalni razvoj / predogled

V mapi `/Users/imac/test claude/.claude/launch.json` je dodana konfiguracija
`stk-adria-koledar`, ki prek Claude Code Browser pane požene lokalni strežnik na
portu 8778 za to mapo (uporabno za nadaljnji razvoj z menoj).
