# PM팀 주간업무보고서 — 배포 가이드

부서원 전체가 동시에 접속해 함께 편집/저장할 수 있는 PWA(웹앱)입니다.
데이터는 Supabase(클라우드 DB)에 저장되며, Vercel로 무료 호스팅합니다.

---

## 1단계. Supabase 설정 (데이터 저장소)

1. https://supabase.com 접속 → 회원가입(무료) → **New project** 생성
   - 프로젝트 이름: 예) `pm-weekly-report`
   - 비밀번호는 아무거나 설정 (직접 안 쓰므로 기억 안 해도 무방)
   - Region은 `Northeast Asia (Seoul)` 선택 권장 (속도 빠름)
2. 프로젝트 생성 완료 후, 왼쪽 메뉴 **SQL Editor** 클릭
3. `supabase-schema.sql` 파일 내용을 전체 복사해 붙여넣고 **Run** 클릭
   → `weekly_reports` 테이블이 생성됩니다.
4. 왼쪽 메뉴 **Project Settings > API** 이동
   - **Project URL** 복사 (예: `https://abcdxyz.supabase.co`)
   - **anon public** key 복사 (긴 문자열)

## 2단계. 코드에 Supabase 정보 입력

`index.html` 파일 상단에서 아래 두 줄을 찾아 방금 복사한 값으로 바꿔주세요.

```javascript
const SUPABASE_URL = 'https://YOUR-PROJECT-REF.supabase.co';
const SUPABASE_ANON_KEY = 'YOUR-ANON-PUBLIC-KEY';
```

## 3단계. Vercel로 배포

1. https://vercel.com 접속 → GitHub 계정으로 가입/로그인 (가장 간단)
2. 이 폴더(`index.html`, `manifest.json`, `sw.js`, `icons/`)를 GitHub 저장소에 업로드
   - GitHub에 저장소가 없다면: github.com에서 새 저장소(New repository) 생성 → 파일 업로드(Upload files)로 이 폴더 안 파일들을 그대로 올리면 됩니다.
3. Vercel 대시보드에서 **Add New > Project** → 방금 만든 GitHub 저장소 선택 → **Deploy** 클릭
   - 별도 빌드 설정 없이 그대로 배포하면 됩니다 (정적 HTML이라 Framework: Other로 자동 인식됩니다).
4. 배포 완료 후 발급되는 URL (예: `https://pm-weekly-report.vercel.app`)을 부서원들에게 공유하세요.

## 4단계. 부서원 사용 방법 (PWA 설치)

- 크롬(PC)에서 URL 접속 → 주소창 오른쪽의 **설치 아이콘** 클릭 → "설치"
  → 바탕화면/시작메뉴에 아이콘이 생겨 앱처럼 실행 가능합니다.
- 별도 설치 없이 그냥 브라우저 즐겨찾기로 써도 동일하게 동작합니다.

---

## 참고사항

- **실시간 동기화**: 한 사람이 체크박스를 누르거나 업무내용을 입력하면, 같은 주차 화면을 보고 있는 다른 부서원 화면에도 자동 반영됩니다 (Supabase Realtime 사용).
- **권한**: 별도 로그인 없이 누구나 조회·수정 가능하도록 설정되어 있습니다 (요청하신 대로).
- **연결 오류 시**: 화면 상단에 빨간 경고 배너가 뜨면 `index.html`의 SUPABASE_URL/KEY 설정을 다시 확인하세요.
- **인원 명단 변경**: `index.html` 안의 `ROSTER` 배열을 수정하면 됩니다.
