-- PM팀 주간업무보고서 - Supabase 테이블 생성 스크립트
-- Supabase 대시보드 > SQL Editor 에서 이 전체를 붙여넣고 [Run] 클릭하세요.

create table if not exists weekly_reports (
  id uuid primary key default gen_random_uuid(),
  week_key text not null unique,        -- 예: '2026-08-17' (해당 주 월요일 날짜)
  data jsonb not null,                  -- 인원별 업무내용/특이사항/근태 데이터 전체
  updated_at timestamptz not null default now()
);

-- week_key로 빠르게 조회하기 위한 인덱스
create index if not exists idx_weekly_reports_week_key on weekly_reports(week_key);

-- Row Level Security 활성화
alter table weekly_reports enable row level security;

-- 부서원 누구나(anon key로) 읽기/쓰기 가능하도록 허용
-- ※ 사내용 도구이므로 별도 로그인 없이 전체 허용합니다.
--   외부에 URL이 노출되지 않도록 주의하세요.
create policy "Allow all read" on weekly_reports
  for select using (true);

create policy "Allow all insert" on weekly_reports
  for insert with check (true);

create policy "Allow all update" on weekly_reports
  for update using (true);
