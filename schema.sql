-- STK Adria — Koledar žerjavov + Naklad/Razklad
-- Zaženi CELOTNO datoteko enkrat v Supabase Dashboard -> SQL Editor -> New query -> Run.

-- ============================================================
-- 1. TABELE
-- ============================================================

create table profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  email text not null,
  full_name text not null default '',
  role text not null check (role in ('admin','viewer')) default 'viewer',
  created_at timestamptz not null default now()
);

-- Katalog modelov (proizvajalčevi PDF-ji) — ločeno od `cranes`, ki so naši konkretni,
-- poimenovani najemni žerjavi. En model (npr. "Terex CTT 152-6") je lahko osnova za več
-- imenovanih žerjavov, vsak v svoji izvedbi (podnožje/stolp/višina/roka).
create table crane_models (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,          -- npr. "Terex CTT 152-6"
  pdf_url text not null,
  notes text,
  created_at timestamptz not null default now()
);

create table cranes (
  id uuid primary key default gen_random_uuid(),
  code text not null unique,          -- šifra, npr. "CTT95-GASPER"
  name text not null,                 -- ime, npr. "Gašper"
  model text not null,                -- npr. "CTT 91" (kratko, kot ga ekipa piše na tablo)
  crane_model_id uuid references crane_models(id),  -- povezava na uradni katalog, ko je znana
  serial_number text,                 -- S/N s table/nalepke
  height_m numeric,                   -- HUH
  jib_m numeric,                      -- JIB
  base_type text,                     -- npr. "ANCHORS", "C45", "CROSS BASE C50 PEINER"
  yard_only boolean not null default false,  -- žerjav na skladišču, se ne oddaja v najem
  notes text,
  active boolean not null default true,
  created_at timestamptz not null default now()
);

create table part_templates (
  id uuid primary key default gen_random_uuid(),
  crane_id uuid not null references cranes(id) on delete cascade,
  part_name text not null,
  qty integer not null default 1,
  sort_order integer not null default 0,
  notes text,
  created_at timestamptz not null default now()
);

create table calendar_events (
  id uuid primary key default gen_random_uuid(),
  crane_id uuid references cranes(id),   -- NULL dovoljen samo za splošna "opravila" (ni vezano na en žerjav)
  type text not null check (type in ('naklad','razklad','opravilo','servis','drugo')),
  title text,
  site_name text,
  start_at timestamptz not null,
  end_at timestamptz,
  notes text,
  urgent boolean not null default false,
  created_by uuid references profiles(id),
  created_at timestamptz not null default now(),
  constraint crane_required_unless_opravilo check (type in ('opravilo','drugo') or crane_id is not null)
);

create table operations (
  id uuid primary key default gen_random_uuid(),
  calendar_event_id uuid not null unique references calendar_events(id) on delete cascade,
  crane_id uuid references cranes(id),
  type text not null check (type in ('naklad','razklad','opravilo','servis')),
  status text not null check (status in ('odprto','zaključeno')) default 'odprto',
  stale_alerted boolean not null default false,
  created_at timestamptz not null default now(),
  closed_at timestamptz
);

create table operation_items (
  id uuid primary key default gen_random_uuid(),
  operation_id uuid not null references operations(id) on delete cascade,
  part_name text not null,
  qty integer not null default 1,
  sort_order integer not null default 0,
  checked boolean not null default false,
  checked_by uuid references profiles(id),
  checked_at timestamptz,
  diverted boolean not null default false,
  diverted_note text,
  source_note text
);

create table pending_notes (
  id uuid primary key default gen_random_uuid(),
  crane_id uuid not null references cranes(id) on delete cascade,
  part_name text not null,
  note text not null,
  created_by uuid references profiles(id),
  created_at timestamptz not null default now(),
  resolved boolean not null default false,
  resolved_at timestamptz
);

create table alerts (
  id uuid primary key default gen_random_uuid(),
  operation_id uuid not null references operations(id) on delete cascade,
  operation_item_id uuid references operation_items(id) on delete cascade,
  message text not null,
  created_at timestamptz not null default now(),
  resolved boolean not null default false,
  resolved_at timestamptz,
  resolved_by uuid references profiles(id)
);

-- ============================================================
-- 2. HELPER: je prijavljeni uporabnik admin?
-- ============================================================

create or replace function is_admin() returns boolean as $$
  select exists(
    select 1 from profiles where id = auth.uid() and role = 'admin'
  );
$$ language sql security definer stable;

-- ============================================================
-- 3. SAMODEJNO: nov uporabnik (povabilo) -> vrstica v profiles
-- ============================================================

create or replace function handle_new_user() returns trigger as $$
begin
  insert into profiles (id, email, full_name)
    values (new.id, new.email, coalesce(new.raw_user_meta_data->>'full_name', split_part(new.email, '@', 1)));
  return new;
end;
$$ language plpgsql security definer;

create trigger trg_new_user
after insert on auth.users
for each row execute function handle_new_user();

-- ============================================================
-- 4. SAMODEJNO: nov koledarski dogodek naklad/razklad -> operacija + postavke
-- ============================================================

create or replace function handle_new_calendar_event() returns trigger as $$
declare
  new_op_id uuid;
  src_op_id uuid;
begin
  if NEW.type = 'naklad' then
    insert into operations (calendar_event_id, crane_id, type)
      values (NEW.id, NEW.crane_id, 'naklad') returning id into new_op_id;

    insert into operation_items (operation_id, part_name, qty, sort_order, source_note)
      select new_op_id, pt.part_name, pt.qty, pt.sort_order,
        pn.note
      from part_templates pt
      left join lateral (
        select note from pending_notes
        where crane_id = NEW.crane_id and part_name = pt.part_name and resolved = false
        order by created_at desc limit 1
      ) pn on true
      where pt.crane_id = NEW.crane_id
      order by pt.sort_order;

  elsif NEW.type = 'razklad' then
    insert into operations (calendar_event_id, crane_id, type)
      values (NEW.id, NEW.crane_id, 'razklad') returning id into new_op_id;

    select o.id into src_op_id
      from operations o
      join calendar_events ce on ce.id = o.calendar_event_id
      where o.crane_id = NEW.crane_id and o.type = 'naklad' and ce.start_at <= NEW.start_at
      order by ce.start_at desc
      limit 1;

    if src_op_id is not null then
      insert into operation_items (operation_id, part_name, qty, sort_order, source_note)
        select new_op_id, part_name, qty, sort_order,
          case when diverted then ('Prejšnjič ni bil vrnjen: ' || coalesce(diverted_note, '')) else null end
        from operation_items
        where operation_id = src_op_id
        order by sort_order;
    end if;

  elsif NEW.type in ('opravilo','servis') then
    -- Naloge ni od kje samodejno povzeti — admin jih doda sam (klient kliče add_task_item
    -- po tem, ko je dogodek ustvarjen). Tu samo ustvarimo operacijo.
    insert into operations (calendar_event_id, crane_id, type)
      values (NEW.id, NEW.crane_id, NEW.type) returning id into new_op_id;
  end if;

  if NEW.urgent then
    insert into alerts (operation_id, operation_item_id, message)
      select o.id, null, '🔴 Nujno — ' || upper(NEW.type) || ': ' || coalesce(NEW.title, '(brez naslova)')
      from operations o where o.calendar_event_id = NEW.id;
  end if;

  return NEW;
end;
$$ language plpgsql security definer;

create trigger trg_new_calendar_event
after insert on calendar_events
for each row execute function handle_new_calendar_event();

-- ============================================================
-- 5. SAMODEJNO: del oznacen "šel je drugam" -> zapomni se za naslednjič
-- ============================================================

create or replace function handle_item_diverted() returns trigger as $$
begin
  if NEW.diverted = true and (OLD.diverted is distinct from true) then
    insert into pending_notes (crane_id, part_name, note, created_by)
      select o.crane_id, NEW.part_name, coalesce(NEW.diverted_note, ''), auth.uid()
      from operations o where o.id = NEW.operation_id;
  end if;
  return NEW;
end;
$$ language plpgsql security definer;

create trigger trg_item_diverted
after update on operation_items
for each row execute function handle_item_diverted();

-- ============================================================
-- 6. SAMODEJNO: razklad zaključen -> opozorilo za vse neobkljukane, ne-preusmerjene dele
-- ============================================================

create or replace function handle_operation_closed() returns trigger as $$
begin
  if NEW.status = 'zaključeno' and OLD.status = 'odprto' and NEW.type = 'razklad' then
    insert into alerts (operation_id, operation_item_id, message)
      select NEW.id, oi.id, 'Manjka pri razkladu: ' || oi.part_name || ' (' || oi.qty || ' kos)'
      from operation_items oi
      where oi.operation_id = NEW.id and oi.checked = false and oi.diverted = false;
  end if;
  return NEW;
end;
$$ language plpgsql security definer;

create trigger trg_operation_closed
after update on operations
for each row execute function handle_operation_closed();

-- ============================================================
-- 7. RPC FUNKCIJE (edina pot do sprememb v operation_items/operations)
-- ============================================================

create or replace function toggle_item_checked(item_id uuid, is_checked boolean) returns void as $$
  update operation_items
    set checked = is_checked,
        checked_by = case when is_checked then auth.uid() else null end,
        checked_at = case when is_checked then now() else null end
    where id = item_id;
$$ language sql security definer;

create or replace function divert_item(item_id uuid, note text) returns void as $$
begin
  if not is_admin() then
    raise exception 'Samo admin lahko označi del kot preusmerjen.';
  end if;
  update operation_items
    set diverted = true, diverted_note = note, checked = false, checked_by = null, checked_at = null
    where id = item_id;
end;
$$ language plpgsql security definer;

create or replace function undo_divert_item(item_id uuid) returns void as $$
begin
  if not is_admin() then
    raise exception 'Samo admin lahko to spremeni.';
  end if;
  update operation_items set diverted = false, diverted_note = null where id = item_id;
end;
$$ language plpgsql security definer;

create or replace function close_operation(op_id uuid) returns void as $$
begin
  if not is_admin() then
    raise exception 'Samo admin lahko zaključi nalaganje/razkladanje.';
  end if;
  update operations set status = 'zaključeno', closed_at = now() where id = op_id and status = 'odprto';
end;
$$ language plpgsql security definer;

create or replace function reopen_operation(op_id uuid) returns void as $$
begin
  if not is_admin() then
    raise exception 'Samo admin lahko to spremeni.';
  end if;
  update operations set status = 'odprto', closed_at = null where id = op_id;
end;
$$ language plpgsql security definer;

create or replace function resolve_pending_note(note_id uuid) returns void as $$
begin
  if not is_admin() then
    raise exception 'Samo admin lahko to spremeni.';
  end if;
  update pending_notes set resolved = true, resolved_at = now() where id = note_id;
end;
$$ language plpgsql security definer;

create or replace function resolve_alert(alert_id uuid) returns void as $$
begin
  if not is_admin() then
    raise exception 'Samo admin lahko to spremeni.';
  end if;
  update alerts set resolved = true, resolved_at = now(), resolved_by = auth.uid() where id = alert_id;
end;
$$ language plpgsql security definer;

-- Doda nalogo na opravilo/servis (admin jih vnese ob ustvarjanju dogodka ali kasneje).
create or replace function add_task_item(op_id uuid, task_name text) returns uuid as $$
declare
  new_id uuid;
  next_order integer;
begin
  if not is_admin() then
    raise exception 'Samo admin lahko doda nalogo.';
  end if;
  select coalesce(max(sort_order), 0) + 1 into next_order from operation_items where operation_id = op_id;
  insert into operation_items (operation_id, part_name, qty, sort_order)
    values (op_id, task_name, 1, next_order) returning id into new_id;
  return new_id;
end;
$$ language plpgsql security definer;

create or replace function delete_task_item(item_id uuid) returns void as $$
begin
  if not is_admin() then
    raise exception 'Samo admin lahko to spremeni.';
  end if;
  delete from operation_items where id = item_id;
end;
$$ language plpgsql security definer;

-- Pokliči ob vsakem zagonu aplikacije (katerikoli prijavljen uporabnik): če je opravilo/servis
-- odprto še naslednji dan (>1 dan) in ima neobkljukane naloge, sproži (enkratno) opozorilo.
create or replace function check_stale_operations() returns void as $$
begin
  insert into alerts (operation_id, operation_item_id, message)
  select o.id, null,
    '⏰ Čaka že več kot 1 dan — ' || upper(o.type) || ': ' || coalesce(ce.title, ce.site_name, '(brez naslova)')
  from operations o
  join calendar_events ce on ce.id = o.calendar_event_id
  where o.type in ('opravilo','servis')
    and o.status = 'odprto'
    and o.stale_alerted = false
    and o.created_at < now() - interval '1 day'
    and exists (select 1 from operation_items oi where oi.operation_id = o.id and oi.checked = false);

  update operations set stale_alerted = true
    where type in ('opravilo','servis') and status = 'odprto' and stale_alerted = false
      and created_at < now() - interval '1 day'
      and exists (select 1 from operation_items oi where oi.operation_id = operations.id and oi.checked = false);
end;
$$ language plpgsql security definer;

-- ============================================================
-- 8. ROW LEVEL SECURITY
-- ============================================================

alter table profiles enable row level security;
alter table crane_models enable row level security;
alter table cranes enable row level security;
alter table part_templates enable row level security;
alter table calendar_events enable row level security;
alter table operations enable row level security;
alter table operation_items enable row level security;
alter table pending_notes enable row level security;
alter table alerts enable row level security;

-- profiles: vsak prijavljen lahko vidi vse (za prikaz imen "obkljukal: ..."), spremeni lahko samo admin
create policy "profiles_select" on profiles for select using (auth.role() = 'authenticated');
create policy "profiles_admin_update" on profiles for update using (is_admin()) with check (is_admin());

-- crane_models (katalog proizvajalca)
create policy "crane_models_select" on crane_models for select using (auth.role() = 'authenticated');
create policy "crane_models_admin_insert" on crane_models for insert with check (is_admin());
create policy "crane_models_admin_update" on crane_models for update using (is_admin()) with check (is_admin());
create policy "crane_models_admin_delete" on crane_models for delete using (is_admin());

-- cranes
create policy "cranes_select" on cranes for select using (auth.role() = 'authenticated');
create policy "cranes_admin_insert" on cranes for insert with check (is_admin());
create policy "cranes_admin_update" on cranes for update using (is_admin()) with check (is_admin());
create policy "cranes_admin_delete" on cranes for delete using (is_admin());

-- part_templates
create policy "part_templates_select" on part_templates for select using (auth.role() = 'authenticated');
create policy "part_templates_admin_insert" on part_templates for insert with check (is_admin());
create policy "part_templates_admin_update" on part_templates for update using (is_admin()) with check (is_admin());
create policy "part_templates_admin_delete" on part_templates for delete using (is_admin());

-- calendar_events: vsi berejo, samo admin ustvarja/ureja/briše
create policy "calendar_events_select" on calendar_events for select using (auth.role() = 'authenticated');
create policy "calendar_events_admin_insert" on calendar_events for insert with check (is_admin());
create policy "calendar_events_admin_update" on calendar_events for update using (is_admin()) with check (is_admin());
create policy "calendar_events_admin_delete" on calendar_events for delete using (is_admin());

-- operations: berejo vsi; vse spremembe gredo skozi RPC (ni insert/update politike za navadne uporabnike)
create policy "operations_select" on operations for select using (auth.role() = 'authenticated');

-- operation_items: berejo vsi; spremembe samo skozi RPC funkcije zgoraj
create policy "operation_items_select" on operation_items for select using (auth.role() = 'authenticated');

-- pending_notes: berejo vsi; spremembe samo skozi RPC
create policy "pending_notes_select" on pending_notes for select using (auth.role() = 'authenticated');

-- alerts: berejo vsi; spremembe samo skozi RPC
create policy "alerts_select" on alerts for select using (auth.role() = 'authenticated');

-- ============================================================
-- 9. REALTIME (da se koledar/naklad/razklad posodablja takoj pri vseh)
-- ============================================================

alter publication supabase_realtime add table calendar_events, operations, operation_items, pending_notes, alerts;

-- ============================================================
-- 10. KATALOG MODELOV — uradni Terex PDF-ji s stk-adria.com (prebrano 12. 10. 2026)
-- ============================================================

insert into crane_models (name, pdf_url) values
('Terex FC6-24', 'https://stk-adria.com/wp-content/uploads/2024/12/Terex-fc6-24h.pdf'),
('Terex CTT 91-5', 'https://stk-adria.com/wp-content/uploads/2024/12/Terex-ctt-91-5.pdf'),
('Terex CTT 121A-5', 'https://stk-adria.com/wp-content/uploads/2024/12/Terex-ctt-121A-5.pdf'),
('Terex CTT 132-6', 'https://stk-adria.com/wp-content/uploads/2024/12/Terex-ctt-132-6.pdf'),
('Terex CTT 141A-6', 'https://stk-adria.com/wp-content/uploads/2024/12/Terex-ctt-141A-6.pdf'),
('Terex CTT 152-6', 'https://stk-adria.com/wp-content/uploads/2024/12/Terex-ctt-152-6.pdf'),
('Terex CTT 161A-6', 'https://stk-adria.com/wp-content/uploads/2024/12/Terex-ctt-161A-6.pdf'),
('Terex CTT 172-8', 'https://stk-adria.com/wp-content/uploads/2024/12/Terex-ctt-172-8.pdf'),
('Terex CTT 181B-8', 'https://stk-adria.com/wp-content/uploads/2024/12/Terex-ctt-181B-8.pdf'),
('Terex CTT 202-8', 'https://stk-adria.com/wp-content/uploads/2024/12/Terex-ctt-202-8.pdf'),
-- POZOR: na strani ima "Terex CTT 202-10" isto povezavo kot "Terex CTT 202-8" (verjetno napaka
-- na spletni strani) — dokler ne dobimo pravega PDF-ja, kaže na isti dokument kot opozorilo.
('Terex CTT 202-10', 'https://stk-adria.com/wp-content/uploads/2024/12/Terex-ctt-202-8.pdf'),
('Terex CTT 222-10', 'https://stk-adria.com/wp-content/uploads/2024/12/Terex-ctt-222-10.pdf'),
('Terex CTT 231-12', 'https://stk-adria.com/wp-content/uploads/2024/12/Terex-ctt-231-12.pdf'),
('Terex CTT 292-12', 'https://stk-adria.com/wp-content/uploads/2024/12/Terex-ctt-292-12.pdf'),
('Terex CTT 332-16', 'https://stk-adria.com/wp-content/uploads/2024/12/Terex-ctt-332-16.pdf'),
('Terex CTT 472-20', 'https://stk-adria.com/wp-content/uploads/2024/12/Terex-ctt-472-20.pdf'),
('Terex CTT 561A-20', 'https://stk-adria.com/wp-content/uploads/2024/12/Terex-ctt-561a-20.pdf'),
('Terex CTT 561A-32', 'https://stk-adria.com/wp-content/uploads/2024/12/Terex-ctt-561a-32.pdf'),
('Terex CTT 721B-40', 'https://stk-adria.com/wp-content/uploads/2024/12/Terex-ctt721b-40.pdf'),
('Terex CBR 21H', 'https://stk-adria.com/wp-content/uploads/2024/12/Terex-cbr-21h.pdf'),
('Terex CBR 24 PLUS', 'https://stk-adria.com/wp-content/uploads/2024/12/Terex-cbr-24-plus.pdf'),
('Terex CBR 28 PLUS', 'https://stk-adria.com/wp-content/uploads/2024/12/Terex-cbr-28-plus.pdf'),
('Terex CBR 32 PLUS', 'https://stk-adria.com/wp-content/uploads/2024/12/Terex-cbr-32-plus.pdf'),
('Terex CBR 40H', 'https://stk-adria.com/wp-content/uploads/2024/12/Terex-cbr-40h.pdf'),
('Terex CSE 30', 'https://stk-adria.com/wp-content/uploads/2024/12/Terex-cse-30.pdf'),
('Terex CSE 32', 'https://stk-adria.com/wp-content/uploads/2024/12/Terex-cse-32.pdf'),
('Terex CSE 36', 'https://stk-adria.com/wp-content/uploads/2024/12/Terex-cse-36.pdf'),
('Terex CSE 40', 'https://stk-adria.com/wp-content/uploads/2024/12/Terex-cse-40.pdf');

-- ============================================================
-- 11. ŽERJAVI (cranes) — s table na skladišču, prebrano s slike 13. 10. 2026,
-- potrjeno z uporabnikom v pogovoru. Samo teh 33 je v floti (dodatnih 5 modelov v
-- katalogu je na voljo prek nizozemskega dobavitelja, niso naša last).
-- model = kratko ime, kot ga ekipa piše na tablo (ni nujno isto kot ime v crane_models).
-- crane_model_id NAMENOMA ni povezan — nekateri modeli na tabli (npr. "CTT 162") se ne
-- ujemajo nedvoumno z nobenim od 28 PDF katalogov; poveži ročno, ko bo jasno.
-- ============================================================

insert into cranes (code, name, model, serial_number, jib_m, height_m, base_type, yard_only, notes) values
('CTT132-JANEZ', 'Janez', 'CTT 132', 'G12020021', 60, 30, 'CROSS BASE', false, null),
('CSE32-SIME', 'Šime', 'CSE 32', 'G12722013', 32, 21, 'ANCHORS', false, null),
('CTT472-MIKE', 'Mike', 'CTT 472', 'G12320006', 75, 62.4, 'ANCHORS', false, null),
('CTT91-GASPER', 'Gašper', 'CTT 91', 'G8407124', 50, 29.05, 'CROSS BASE C38', false, null),
('CBR32-LADKO', 'Ladko', 'CBR 32', 'G9512001', 32, 21, 'ANCHORS', false, null),
('CTT91-LUBO', 'Lubo', 'CTT 91', 'G8405103', 25, 25, 'ANCHORS', false, null),
('CTT91-ZOKI', 'Zoki', 'CTT 91', 'G8406010', 50, 34.95, 'C38', false, null),
('CTT132-MIMI', 'Mimi', 'CTT 132', 'G13724002', 50, 29, 'C45', false, null),
('CTT231-PRINCMUFTI', 'Princ Mufti', 'CTT 231', 'G9813012', 50, 56.30, 'C60', false, null),
('CTT161-MARCOPOLO', 'Marco Polo', 'CTT 161', 'G7610012', 60, 44.70, 'C45', false, null),
('CSE32-CASPER', 'Casper', 'CSE 32', 'G12721017', 32, 21.5, 'ANCHORS', false, null),
('CTT182-ALPHONSE', 'Monsieur Alphonse', 'CTT 182', 'G11618004', 40, 38.80, 'C45', false, null),
('CTT91-DONALD', 'Donald', 'CTT 91', 'G8420010', 50, 39.85, 'ANCHORS / C58', false, null),
('CTT91-SUSHI', 'Sushi', 'CTT 91', 'G8407093', 40, 34, 'SIDRA TS12', false, null),
('CTT231-PRINCESSLEIA', 'Princess Leia', 'CTT 231', 'G9813004', 70, 56.30, 'TS25', false, null),
('CTT181-LIONKING', 'Lion King', 'CTT 181', 'G8107024', 60, 32.9, 'BASE', false, null),
('CTT182-CALIMERO', 'Calimero', 'CTT 182', 'G11617017', 55, 25, 'C45', false, null),
('CTT231-JAMESBOND', 'James Bond', 'CTT 231', 'G9812007', 70, 56.30, 'C60', false, null),
('CTT182-RAMBO', 'Rambo', 'CTT 182', 'G11617003', 60, 38.8, 'C45', false, null),
('CTT162-LADYDIANA', 'Lady Diana', 'CTT 162', 'G11716012', 55, 27, 'C45', false, null),
('CTT231-RUDA', 'Ruda', 'CTT 231', 'G9813008', 65, 45, 'C60', false, null),
('CTT162-IVETTE', 'Ivette', 'CTT 162', 'G11717003', 40, 43, 'ANCHORS', false, null),
('CTT152-CAFFEREN', 'Caffe Ren', 'CTT 152', 'G14124006', 50, 44.5, 'C38', false, 'Potrjeno s katalogom: 44,5 m je pravilna višina (ne 45, kot je prvotno pisalo na tabli).'),
('CTT181-TOMJONES', 'Tom Jones', 'CTT 181', 'G8107115', 60, 38.8, 'C45', false, null),
('CTT231-TITO', 'Tito', 'CTT 231', 'G9813009', 65, 44.5, 'C60', false, null),
('CTT332-KINGCHARLES', 'King Charles', 'CTT 332', 'G12921003', 35, 20, 'ANCHORS', false, null),
('CTT181-MYSHARONA', 'My Sharona', 'CTT 181', 'G8111006', 60, 38.8, 'CROSS BASE C50 PEINER', false, null),
('CTT162-CICIMICI', 'Cicimici', 'CTT 162', 'G11716016', 60, 44, 'CROSS BASE C45', false, null),
('CTT231-MRNICE', 'Mr. Nice', 'CTT 231', 'G9812008', null, 0, null, true, 'JIB: NO.1, CAB. Na tabli ročno označeno "YARD CRANE".'),
('CTT231-10-YARDI', 'Yardi', 'CTT 231-10', 'G9808015', 50, 20, 'C60', true, 'Žerjav za nakladanje/razkladanje drugih žerjavov na skladišču — se ne oddaja v najem.'),
('CSE32-MERCURY', 'Mercury', 'CSE 32', 'G12721018', 32, 21.5, 'ANCHORS', false, null),
('CSE32-COPERNICUS', 'Copernicus', 'CSE 32', 'G12721014', 32, 21.5, 'ANCHORS', false, null),
('CTT161-SNOOPY', 'Snoopy', 'CTT 161', 'G7602018', null, 0, null, false, 'JIB: NO.1, CAB. Podnožje/sidra neznano.');

-- ============================================================
-- Konec. Po tem:
-- 1) Authentication -> Users -> Invite user, za vsakega člana ekipe (email).
--    Štirje admini: megi.podbregar@gmail.com (Marjetka Podbregar), gerryosome@gmail.com
--    (Vladimir Podbregar), sesko.tomi1@gmail.com (Tomi Sesko), rtrauner007@gmail.com
--    (Robert Trauner). Vsi ostali povabljeni (delavci) ostanejo privzeto 'viewer'.
-- 2) Za štiri admine poženi (po njihovi prvi prijavi, da obstaja vrstica v profiles):
--    update profiles set role = 'admin' where email in
--      ('megi.podbregar@gmail.com', 'gerryosome@gmail.com', 'sesko.tomi1@gmail.com',
--       'rtrauner007@gmail.com');
-- 3) Vseh 33 žerjavov (ki gredo v naklad/razklad) je že v tabeli cranes (glej zgoraj) —
--    "Yardi" (dvoriščni, se ne oddaja v najem) namenoma nima nakladalne liste.
--    Nakladalne liste za vse so v ločeni datoteki part_templates.sql — zaženi jo po tej
--    datoteki. To so DEFAULT sestave iz Terex katalogov; nekatere imajo opombo "preveri"
--    (nestandardne višine, nejasne oznake na tabli) — admin jih prilagodi po potrebi v
--    Uprava → Žerjavi → Lista.
-- ============================================================
