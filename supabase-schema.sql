-- AXORA Supabase schema. Run once in Supabase SQL Editor.
create extension if not exists pgcrypto;
create table if not exists public.profiles(id uuid primary key references auth.users(id) on delete cascade,email text unique not null,display_name text not null default 'AXORA User',avatar_url text,created_at timestamptz not null default now());
create table if not exists public.user_roles(user_id uuid primary key references auth.users(id) on delete cascade,role text not null check(role='admin'));
create table if not exists public.conversations(id uuid primary key default gen_random_uuid(),is_group boolean not null default false,title text,created_at timestamptz not null default now());
create table if not exists public.conversation_members(conversation_id uuid not null references public.conversations(id) on delete cascade,user_id uuid not null references auth.users(id) on delete cascade,joined_at timestamptz not null default now(),primary key(conversation_id,user_id));
create table if not exists public.messages(id uuid primary key default gen_random_uuid(),conversation_id uuid not null references public.conversations(id) on delete cascade,sender_id uuid not null references auth.users(id) on delete cascade,body text not null check(length(body) between 1 and 4000),created_at timestamptz not null default now());
create index if not exists messages_room_time on public.messages(conversation_id,created_at);
create table if not exists public.reports(id uuid primary key default gen_random_uuid(),reporter_id uuid not null references auth.users(id) on delete cascade,reason text not null,details text,status text not null default 'open' check(status in('open','resolved')),created_at timestamptz not null default now());
create or replace function public.is_current_user_admin() returns boolean language sql stable security definer set search_path=public as $$select exists(select 1 from public.user_roles where user_id=auth.uid() and role='admin')$$;
create or replace function public.is_conversation_member(cid uuid) returns boolean language sql stable security definer set search_path=public as $$select exists(select 1 from public.conversation_members where conversation_id=cid and user_id=auth.uid())$$;
create or replace function public.create_direct_conversation(target_user uuid) returns uuid language plpgsql security definer set search_path=public as $$declare cid uuid;begin if auth.uid() is null or target_user=auth.uid() then raise exception 'Invalid user';end if;if not exists(select 1 from public.profiles where id=target_user) then raise exception 'User not found';end if;select c.id into cid from public.conversations c join public.conversation_members a on a.conversation_id=c.id and a.user_id=auth.uid() join public.conversation_members b on b.conversation_id=c.id and b.user_id=target_user where c.is_group=false limit 1;if cid is null then insert into public.conversations default values returning id into cid;insert into public.conversation_members values(cid,auth.uid(),now()),(cid,target_user,now());end if;return cid;end$$;
grant execute on function public.is_current_user_admin() to authenticated;grant execute on function public.create_direct_conversation(uuid) to authenticated;
alter table public.profiles enable row level security;alter table public.user_roles enable row level security;alter table public.conversations enable row level security;alter table public.conversation_members enable row level security;alter table public.messages enable row level security;alter table public.reports enable row level security;
create policy profiles_select on public.profiles for select to authenticated using(true);
create policy profiles_insert on public.profiles for insert to authenticated with check(id=auth.uid() and email=auth.jwt()->>'email');
create policy profiles_update on public.profiles for update to authenticated using(id=auth.uid()) with check(id=auth.uid() and email=auth.jwt()->>'email');
create policy roles_select on public.user_roles for select to authenticated using(user_id=auth.uid() or public.is_current_user_admin());
create policy conversations_select on public.conversations for select to authenticated using(public.is_conversation_member(id) or public.is_current_user_admin());
create policy members_select on public.conversation_members for select to authenticated using(public.is_conversation_member(conversation_id) or public.is_current_user_admin());
create policy messages_select on public.messages for select to authenticated using(public.is_conversation_member(conversation_id));
create policy messages_insert on public.messages for insert to authenticated with check(sender_id=auth.uid() and public.is_conversation_member(conversation_id));
create policy reports_insert on public.reports for insert to authenticated with check(reporter_id=auth.uid() and status='open');
create policy reports_select on public.reports for select to authenticated using(public.is_current_user_admin());
create policy reports_update on public.reports for update to authenticated using(public.is_current_user_admin()) with check(public.is_current_user_admin());
do $$begin alter publication supabase_realtime add table public.messages;exception when duplicate_object then null;when undefined_object then null;end$$;
-- After your first account is created, run this separately after replacing the email:
-- insert into public.user_roles(user_id,role) select id,'admin' from auth.users where email='YOUR_EMAIL' on conflict(user_id) do update set role='admin';
