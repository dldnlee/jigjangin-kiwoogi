export const VERSION = 'browser-slice-1';
export const ranks = [
  {id:'new_hire',name:'신입',rate:100,level:1,performance:0,work:0,expertise:0,reputation:0},
  {id:'employee',name:'사원',rate:180,level:2,performance:30,work:1,expertise:0,reputation:0},
  {id:'assistant_manager',name:'대리',rate:500,level:4,performance:60,work:3,expertise:1,reputation:5},
  {id:'manager',name:'과장',rate:900,level:7,performance:100,work:5,expertise:2,reputation:10},
  {id:'general_manager',name:'부장',rate:2800,level:10,performance:160,work:8,expertise:3,reputation:20}
];
export const companies = [
  {id:'paper_sprout',name:'종이새싹',salary:10000,difficulty:0,expertise:0,desc:'작은 시작, 꾸준한 성장.',tag:'편안한 출발',theme:'sprout'},
  {id:'moon_mug',name:'달빛머그',salary:12000,difficulty:500,expertise:2,desc:'좋은 커피와 적당한 야망.',tag:'균형 잡힌 일상',theme:'moon'},
  {id:'cloud_step',name:'구름계단',salary:15000,difficulty:1500,expertise:4,desc:'높은 연봉, 까다로운 평가.',tag:'더 큰 도전',theme:'cloud'}
];
export const upgrades = [
  {id:'speed',name:'업무속도',base:500,icon:'bolt',desc:'급여 배율 +5%p',flavor:'단축키 하나로 달라지는 하루'},
  {id:'efficiency',name:'업무효율',base:700,icon:'chart',desc:'급여 배율 +5%p',flavor:'같은 일도 조금 더 똑똑하게'},
  {id:'focus',name:'집중력',base:600,icon:'target',desc:'경험치 +0.1 /초',flavor:'알림은 잠시, 몰입은 길게'}
];
export const skills = [
  {id:'work',name:'업무력',icon:'case',desc:'급여 배율 +1%p · 10레벨마다 성과/분 +1'},
  {id:'expertise',name:'전문성',icon:'book',desc:'경험치 +0.02 /초 · 이직 조건 달성'},
  {id:'talk',name:'말빨',icon:'chat',desc:'이직 협상 +0.5%p · 특별 대화 선택지'}
];
const gear = [
 ['laptop_01','중고 노트북','laptop',2000,0,{work:1}],
 ['laptop_02','가벼운 노트북','laptop',12000,1,{work:3}],
 ['laptop_03','프로 노트북','laptop',60000,2,{work:6},200],
 ['phone_01','알뜰 스마트폰','phone',2500,0,{talk:1}],
 ['phone_02','깔끔한 스마트폰','phone',15000,1,{talk:3}],
 ['suit_01','구김 적은 셔츠','suit',3000,0,{talk:1}],
 ['suit_02','맞춤 재킷','suit',18000,1,{talk:4}],
 ['shoes_01','편안한 운동화','shoes',2000,0,{work:1}],
 ['shoes_02','단정한 구두','shoes',14000,1,{work:3}],
 ['watch_01','심플한 손목시계','watch',4000,1,{expertise:1}],
 ['watch_02','정교한 손목시계','watch',24000,2,{expertise:3}],
 ['bag_01','튼튼한 에코백','bag',2500,0,{expertise:1}],
 ['bag_02','매일의 서류가방','bag',16000,1,{expertise:3}],
 ['accessory_01','작은 명함지갑','accessory',3500,0,{work:1,talk:1}],
 ['accessory_02','나만의 만년필','accessory',20000,2,{work:2,expertise:2}]
];
export const equipment = gear.map(([id,name,slot,price,rank,flat,income=0])=>({id,name,slot,price,rank,flat,income,rarity:id==='laptop_03'?'레어':id.endsWith('02')?'고급':'일반'}));
export const slots = {laptop:'노트북',phone:'휴대폰',suit:'의상',shoes:'신발',watch:'시계',bag:'가방',accessory:'액세서리'};
const briefs = [
 ['meeting_loop','회의가 회의를 낳았다','다음 회의를 정하기 위한 회의. 누군가 정리가 필요해 보여요.','핵심을 요약한다',{performance:5,reputation:5},'차분히 듣는다',{performance:2}],
 ['printer_jam','프린터가 파업했다','보고서는 완성. 프린터는 아직 마음의 준비가 안 됐네요.','종이를 빼고 고친다',{reputation:5},'지원을 요청한다',{performance:2}],
 ['late_request','퇴근 직전 부탁','“이거 간단한 건데…” 간단함의 기준을 맞춰볼 시간이에요.','업무 범위를 합의한다',{reputation:5},'내일 진행하자고 제안한다',{stress:-5}],
 ['coffee_queue','커피 줄이 길다','커피 머신 앞에 작은 네트워킹 행사가 열렸어요.','동료와 이야기한다',{reputation:5},'자리로 돌아간다',{performance:3}],
 ['typo_rescue','발표 오탈자 발견','완벽한 발표 자료에서 아주 작은 오타를 발견했어요.','조용히 알려준다',{reputation:5},'함께 수정한다',{performance:5}],
 ['lunch_vote','점심 메뉴 투표','오늘의 중요한 의사결정: 무엇을 먹을까요?','새로운 메뉴를 고른다',{stress:-3},'익숙한 메뉴를 고른다',{stress:-2}],
 ['inbox_storm','메일함 폭주','받은 편지함의 숫자가 두 자릿수를 넘어섰어요.','우선순위별로 분류한다',{performance:8},'동료에게 도움을 요청한다',{reputation:3}],
 ['desk_plant','책상 화분 새잎','작은 화분에서 새잎이 났어요. 우리 둘 다 자라는 중.','물을 주며 돌본다',{stress:-4},'동료에게 자랑한다',{reputation:2}],
 ['forgotten_badge','출입증을 잊었다','가방에는 모든 것이 있지만, 출입증만 없네요.','정해진 절차를 따른다',{reputation:3},'안내 데스크를 찾는다',{performance:1}],
 ['calendar_tetris','겹친 일정','캘린더의 네모들이 같은 시간을 차지하려고 해요.','우선순위를 협의한다',{performance:5},'내 일정을 공유한다',{reputation:5}],
 ['silent_call','음소거된 발표','열심히 설명했는데, 마이크가 꺼져 있었어요.','웃으며 다시 시작한다',{stress:-3},'핵심만 다시 전달한다',{performance:4}],
 ['team_credit','프로젝트 칭찬','방금 팀 전체에게 칭찬 메일이 왔어요. 꽤 뿌듯한 순간.','동료들과 공을 나눈다',{reputation:8},'성과를 기록한다',{performance:8}],
 ['useful_template','템플릿 발견','한 시간짜리 일을 십 분으로 줄일 템플릿을 찾았어요.','팀에 공유한다',{reputation:5},'바로 적용한다',{performance:8}],
 ['small_bonus','작은 성과급','꾸준한 노력을 알아봐 주었어요. 작은 보너스가 도착했네요.','성과급을 받는다',{cash:1000},'팀에 감사를 전한다',{reputation:8}],
 ['free_seminar','무료 세미나','관심 있던 분야의 무료 세미나가 열려요.','발표를 듣는다',{performance:5},'참가자와 교류한다',{reputation:5}],
 ['window_break','창밖 잠깐 보기','모니터 밖에도 넓은 세상이 있었네요. 잠깐 쉬어가요.','가볍게 스트레칭한다',{stress:-6},'동료와 산책한다',{reputation:2,stress:-3}],
 ['noisy_keyboard','키보드 소음','옆자리의 타자 소리가 오늘따라 경쾌하네요. 아주 많이.','정중하게 부탁한다',{stress:-4},'자리를 조정한다',{performance:3}],
 ['file_name','최종진짜최종 파일','최종_v3_진짜최종_수정본. 이제 정리가 필요해요.','파일명 규칙을 제안한다',{reputation:5},'폴더를 정리한다',{performance:7}],
 ['helpful_newcomer','신입의 질문','새로운 동료가 조심스럽게 질문을 건넸어요.','차근차근 설명한다',{reputation:5},'도움 되는 자료를 공유한다',{performance:3,reputation:2}],
 ['honest_estimate','일정 추정','“언제까지 될까요?” 현실적인 계획이 필요한 순간이에요.','여유를 포함해 잡는다',{stress:-4},'협업을 제안한다',{reputation:5}]
];
export const events = briefs.map(([id,title,body,a,ae,b,be])=>({id,title,body,positive:['team_credit','useful_template','small_bonus','free_seminar'].includes(id),choices:[{text:a,effects:ae},{text:b,effects:be},...(id==='late_request'?[{text:'우선순위를 함께 정해요',effects:{performance:5,reputation:5},talk:3}]:[])]}));
