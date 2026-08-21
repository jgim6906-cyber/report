-- ============================================================
-- v2 마이그레이션: 업무PM팀 / 공사PM팀 다중 부서 + 인원 관리 지원
-- Supabase SQL Editor에서 전체를 붙여넣고 Run 하세요.
-- (이미 처음 supabase-schema.sql을 실행하신 상태를 전제로 합니다)
-- ============================================================

-- 1) weekly_reports 테이블에 부서 구분 컬럼 추가
alter table weekly_reports add column if not exists dept_key text not null default 'biz';

-- 2) 기존 week_key 단독 unique 제약을 (dept_key, week_key) 복합 unique로 변경
alter table weekly_reports drop constraint if exists weekly_reports_week_key_key;
alter table weekly_reports add constraint weekly_reports_dept_week_key unique (dept_key, week_key);
create index if not exists idx_weekly_reports_dept_week on weekly_reports(dept_key, week_key);

-- 3) 부서별 인원 명단 테이블 (신규)
create table if not exists rosters (
  dept_key text primary key,
  people jsonb not null,
  updated_at timestamptz not null default now()
);
alter table rosters enable row level security;
create policy "Allow all read roster" on rosters for select using (true);
create policy "Allow all insert roster" on rosters for insert with check (true);
create policy "Allow all update roster" on rosters for update using (true);

-- 4) 업무PM팀 초기 명단 등록 (기존 인원 그대로)
insert into rosters (dept_key, people) values
('biz', '[
  {"id":"p1","rank":"실장","name":"강수철","manager":true},
  {"id":"p2","rank":"부장","name":"정병현","manager":true},
  {"id":"p3","rank":"수석","name":"박근호","manager":false},
  {"id":"p4","rank":"책임","name":"김영식","manager":false},
  {"id":"p5","rank":"책임","name":"정준석","manager":false},
  {"id":"p6","rank":"책임","name":"권록율","manager":false},
  {"id":"p7","rank":"선임","name":"황정연","manager":false},
  {"id":"p8","rank":"선임","name":"오인순","manager":false},
  {"id":"p9","rank":"대리","name":"김진수","manager":false},
  {"id":"p10","rank":"주임","name":"한혜진","manager":false},
  {"id":"p11","rank":"주임","name":"이우근","manager":false}
]'::jsonb)
on conflict (dept_key) do nothing;

-- 5) 공사PM팀은 빈 명단으로 시작 (화면의 "인원관리" 탭에서 직접 추가하세요)
insert into rosters (dept_key, people) values ('construction', '[]'::jsonb)
on conflict (dept_key) do nothing;

-- ============================================================
-- 참고: 기존에 입력해두신 주간 데이터(예: 지난주 업무내용)는
-- dept_key='biz'(업무PM팀)로 자동 유지되지만, 예전 코드는 인원을
-- "이름" 기준으로 저장했고 새 코드는 인원 고유 id 기준으로 동작합니다.
-- 따라서 과거에 입력한 텍스트/체크 내용은 새 화면에서는 비어 보일 수
-- 있습니다. 이번 주부터 새로 입력해 주세요 (다음 주부터는 정상 저장/조회됩니다).
-- ============================================================
