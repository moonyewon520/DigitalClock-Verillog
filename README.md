# Digital Clock (Timer / Stopwatch / Alarm) – Verilog on ZedBoard

## 간단 소개
- Verilog로 구현한 **디지털 시계** 프로젝트
- 모드: **Clock(시계 설정/표시) / Timer(카운트다운) / Stopwatch(스탑워치) / Alarm(알람)**
- 표시: **6-Digit 7-Segment** (HH:MM:SS)
- 보드: **ZedBoard**, Tool: **Vivado 2020.2**

## 조작키 (top.v 기준)
> Dip Switch 4개 : 모드 설정
> Push Button 4개 : 조작키
- **모드 선택**: `btn[7:5]` → `ctrl.v`에서 해석 → 출력 `a,b,c,d`
  - `a=1` : **Timer 모드**
  - `b=1` : **Stopwatch 모드**
  - `c=1` : **Alarm 모드**
  - `d=1` : **Clock 설정 모드(시/분/초 편집)**
  - (정확한 매핑은 `ctrl.v` 로직을 따릅니다)
- **편집/시작/확인 공통 버튼**: `btn[4]` (코드에서 `~btn_out[4]`로 사용, **Active-low** 역할)
  - Clock/Alarm/Timer에서 **확인/시작/정지/시간설정** 등으로 쓰임
- **편집 네비게이션(커서/증감)**: `btn_out_pulse[3:0]` = **Left, Right, Up, Down**
  - `timecontrol` 모듈 입력 순서: `(left, right, up, down)
- **Stopwatch Start/Stop**: `btn_out_pulse[1]`(= Up 펄스) 입력 사용
- **초기화 버튼** : 초기화 버튼으로 초기화 (모든 모드에서 사용 가능)

## 동작 모드
- **Clock**
  - 카운터: `Counter` (1 Hz 기반 HH:MM:SS)
  - 설정: `d=1` + `~btn_out[4]` 유효 시 `timecontrol`로 자리수 이동/증감
  - 표시: 선택 자리 **깜빡임**
- **Timer**
  - 설정: `timecontrol`로 설정 값(`nt_*`) 편집 → `btn[4]`로 시작/정지
  - 동작: `timer`(1 Hz 카운트다운), 동작 중에는 일부 자리 **1 Hz 깜박임**
  - 완료: `blink` 신호로 시각적 피드백
- **Stopwatch**
  - `stopwatch` (6 MHz 입력, 내부 분주)  
  - `btn_out_pulse[1]`로 **시작/정지**, `b=1`일 때 동작
- **Alarm**
  - 설정: `timecontrol`로 알람 시/분 편집(`na_*`) → `btn[4]`로 무장/해제
  - 비교: 현재 시각과 일치 시 `alert=1`
  - `alert` 동안 자리 **깜빡임**로 표시

## 표시/세그먼트 구동
- `dec7` : 4bit → 7-seg 패턴 변환 (0~9)
- `seg_data_array`(48비트) 구성:  
  `{H1, dp5, H0, dp4, M1, dp3, M0, dp2, S1, dp1, S0, dp0}`  
  - dp(소수점) 위치를 커서/상태에 따라 **깜빡임/상시표시**로 사용
- `shift` : **600 Hz** 멀티플렉싱으로 `seg_data[7:0]`, `seg_com[5:0]` 구동

## 파일/모듈 (주요 연결)
- `top.v` : 전체 통합(클럭/모드/표시/버튼/배선)
- `clk_wiz_0` : 6 MHz 생성
- `clk_divider` : 1 Hz, 600 Hz 분주
- `debounce` : 8-버튼 디바운스 + 펄스 생성
- `ctrl.v` : `btn[7:5]` → `a(타이머) / b(스탑워치) / c(알람) / d(시계설정)` 해석
- `Counter` : 실제 시계 카운팅(HH:MM:SS)
- `timecontrol.v` : 자리 선택/증감 & 커서 블링크
- `timer.v`, `timer_control.v` : 타이머 동작/설정
- `stopwatch.v` : 스탑워치
- `alarm.v` : 알람 설정/비교/알림(`alert`)
- `dec7` : 7-세그 변환
- `shift.v` : 세그먼트 스캔(멀티플렉싱)

## 한계
- 스탑워치 **ms 단위 표시 없음**(6-Digit 제한)
- `btn[4]`는 코드상 **Active-low** 취급 → 하드웨어 연결 시 극성 확인 필요
