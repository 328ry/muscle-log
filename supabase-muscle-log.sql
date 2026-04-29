-- Muscle Log personal Supabase setup
-- Run this in the SQL editor of the personal Supabase project used by this PWA.

create extension if not exists pgcrypto;

create table if not exists public.muscle_log_records (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  record_date date not null,
  memo text not null default '',
  exercises jsonb not null default '[]'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (user_id, record_date)
);

alter table public.muscle_log_records enable row level security;

drop policy if exists "muscle_log_select_own" on public.muscle_log_records;
drop policy if exists "muscle_log_insert_own" on public.muscle_log_records;
drop policy if exists "muscle_log_update_own" on public.muscle_log_records;
drop policy if exists "muscle_log_delete_own" on public.muscle_log_records;

create policy "muscle_log_select_own"
on public.muscle_log_records
for select
to authenticated
using ((select auth.uid()) = user_id);

create policy "muscle_log_insert_own"
on public.muscle_log_records
for insert
to authenticated
with check ((select auth.uid()) = user_id);

create policy "muscle_log_update_own"
on public.muscle_log_records
for update
to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

create policy "muscle_log_delete_own"
on public.muscle_log_records
for delete
to authenticated
using ((select auth.uid()) = user_id);

create or replace function public.set_muscle_log_records_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists muscle_log_records_updated_at on public.muscle_log_records;
create trigger muscle_log_records_updated_at
before update on public.muscle_log_records
for each row
execute function public.set_muscle_log_records_updated_at();
