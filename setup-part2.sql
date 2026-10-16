create table if not exists skins (
  id bigserial primary key, brand text, series text, model text,
  file_url text, preview_url text, created_at timestamptz default now()
);
alter table skins enable row level security;
create policy "skins read" on skins for select using (auth.role()='authenticated');
create policy "skins admin" on skins for all using (auth.jwt()->>'email'='saaqirashid@gmail.com');
insert into storage.buckets (id,name,public) values ('skins','skins',true) on conflict do nothing;
create policy "skins files read" on storage.objects for select using (bucket_id='skins');
create policy "skins files admin insert" on storage.objects for insert with check (bucket_id='skins' and auth.jwt()->>'email'='saaqirashid@gmail.com');
create policy "skins files admin delete" on storage.objects for delete using (bucket_id='skins' and auth.jwt()->>'email'='saaqirashid@gmail.com');
