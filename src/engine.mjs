import {VERSION,ranks,companies,upgrades,skills,equipment,slots,events} from './content.mjs';
export const MAX_MONEY=10n**30n;
const cap=(n,a,b)=>Math.min(b,Math.max(a,n));
export function fresh(now,seed=1){
  return {version:1,config:VERSION,revision:0,last:now,remainder:0,seconds:0,cash:'0',earned:'0',xp:0,xpRemainder:0,level:1,rank:0,company:'paper_sprout',negotiated:0,performance:0,reputation:0,stress:0,upgrades:{speed:0,efficiency:0,focus:0},skills:{work:0,expertise:0,talk:0},inventory:[],equipped:Object.fromEntries(Object.keys(slots).map(k=>[k,null])),failures:0,nextAttempt:0,offers:[],pending:null,cooldowns:{},rng:{promotion:seed||1,offers:nextRandom(seed||1),events:nextRandom(nextRandom(seed||1))},journal:[],settings:{reducedMotion:false,sound:false},offline:null,receipts:[]};
}
export function nextRandom(seed){let x=seed>>>0;x^=x<<13;x^=x>>>17;x^=x<<5;return x>>>0;}
function random(s,stream,bound){const limit=4294967296-4294967296%bound;let n;do{s.rng[stream]=nextRandom(s.rng[stream]);n=s.rng[stream];}while(n>=limit);return n%bound;}
export function cost(base,level,growth=115){const d=100n**BigInt(level);return (BigInt(base)*BigInt(growth)**BigInt(level)+d-1n)/d;}
export function effective(s,id){return cap(s.skills[id]+Object.values(s.equipped).reduce((n,key)=>n+(equipment.find(e=>e.id===key)?.flat[id]||0),0),0,150);}
export function rate(s){
 let r=BigInt(ranks[s.rank].rate)*BigInt(companies.find(c=>c.id===s.company).salary+s.negotiated)/10000n;
 r=r*BigInt(10000+500*s.upgrades.speed+500*s.upgrades.efficiency)/10000n;
 r=r*BigInt(10000+100*effective(s,'work'))/10000n;
 const bonus=Math.min(3000,Object.values(s.equipped).reduce((n,id)=>n+(equipment.find(e=>e.id===id)?.income||0),0));
 return r*BigInt(10000+bonus)/10000n;
}
export function xpRate(s){return 1000+100*s.upgrades.focus+20*effective(s,'expertise');}
export function unlocked(s){return Object.values(s.upgrades).some(v=>v>0);}
function credit(s,amount){s.cash=String(BigInt(s.cash)+amount>MAX_MONEY?MAX_MONEY:BigInt(s.cash)+amount);s.earned=String(BigInt(s.earned)+amount>MAX_MONEY?MAX_MONEY:BigInt(s.earned)+amount);}
function log(s,text){s.journal.unshift({seconds:s.seconds,text});s.journal=s.journal.slice(0,500);}
function eventDraw(s){
 if(s.pending)return;
 const eligible=events.filter(e=>!s.cooldowns[e.id]||s.cooldowns[e.id]<=s.seconds).sort((a,b)=>a.id.localeCompare(b.id));
 if(!eligible.length)return;
 const categories=[false,true].filter(p=>eligible.some(e=>e.positive===p));
 const category=categories[random(s,'events',categories.length)];
 const pool=eligible.filter(e=>e.positive===category);
 const event=pool[random(s,'events',pool.length)];
 s.pending={id:`event-${s.seconds}`,eventId:event.id,rate:String(rate(s))};
 s.cooldowns[event.id]=s.seconds+1800;
}
export function advance(input,seconds){
 if(!Number.isSafeInteger(seconds)||seconds<0||seconds>28800)throw Error('Invalid simulation duration');
 const s=structuredClone(input);const end=s.seconds+seconds;
 while(s.seconds<end){
  const nextMinute=(Math.floor(s.seconds/60)+1)*60;
  const nextOffer=(Math.floor(s.seconds/600)+1)*600;
  const nextEvent=s.seconds<120?120:120+(Math.floor((s.seconds-120)/300)+1)*300;
  const boundary=Math.min(end,nextMinute,nextOffer,nextEvent);
  const dt=boundary-s.seconds;credit(s,rate(s)*BigInt(dt));
  const mx=xpRate(s)*dt+s.xpRemainder;s.xp+=Math.floor(mx/1000);s.xpRemainder=mx%1000;
  while(s.level<100&&s.xp>=100*s.level*s.level){s.xp-=100*s.level*s.level;s.level++;}
  s.xp=Math.min(1e12,s.xp);s.seconds=boundary;
  if(boundary===nextMinute)s.performance=cap(s.performance+6+Math.floor(effective(s,'work')/10),0,1000);
  s.offers=s.offers.filter(o=>o.expires>s.seconds);
  if(boundary===nextOffer&&s.rank>=1){
   const pool=companies.filter(c=>c.id!==s.company);s.offers=[];
   while(pool.length){const c=pool.splice(random(s,'offers',pool.length),1)[0];s.offers.push({id:`${boundary}-${c.id}`,company:c.id,expires:boundary+1800});}
  }
  if(boundary===nextEvent)eventDraw(s);
 }
 return s;
}
export function settle(input,now,away=false){
 if(!Number.isSafeInteger(now)||now<0)throw Error('Invalid clock');
 const elapsed=Math.max(0,now-input.last);const credited=Math.min(elapsed,28800000)+input.remainder;
 let s=advance(input,Math.floor(credited/1000));s.remainder=credited%1000;s.last=Math.max(input.last,now);
 if(away&&elapsed>=60000){
  const old=s.offline;s.offline={seconds:Math.floor(credited/1000)+(old?.seconds||0),cash:String(BigInt(s.cash)-BigInt(input.cash)+BigInt(old?.cash||'0')),capped:elapsed>28800000||!!old?.capped};
 }
 return s;
}
export function promotion(s){
 const target=ranks[s.rank+1];if(!target)return {target:null,requirements:[],chance:0,ready:false,cooldown:0};
 const requirements=[['레벨',s.level,target.level],['성과',s.performance,target.performance],['업무력',effective(s,'work'),target.work],['전문성',effective(s,'expertise'),target.expertise],['평판',s.reputation,target.reputation]];
 const chance=s.failures>=3?10000:Math.min(10000,Math.max(1000,7000-companies.find(c=>c.id===s.company).difficulty)+1000*s.failures);
 const cooldown=Math.max(0,s.nextAttempt-s.seconds);
 return {target,requirements,chance,cooldown,ready:requirements.every(([,a,b])=>a>=b)&&!cooldown};
}
export function command(input,cmd){
 if(!cmd||typeof cmd.id!=='string'||cmd.id.length>100)throw Error('Invalid command');
 if(input.receipts.includes(cmd.id))return {state:input,message:'이미 반영된 요청이에요.'};
 if(cmd.revision!==input.revision)throw Error('화면이 갱신됐어요. 다시 시도해 주세요.');
 const s=structuredClone(input);let message='';
 const pay=n=>{if(BigInt(s.cash)<n)throw Error('잔액이 부족해요. 자동 급여를 조금 더 모아 주세요.');s.cash=String(BigInt(s.cash)-n);};
 switch(cmd.kind){
  case 'upgrade':{const u=upgrades.find(x=>x.id===cmd.key);if(!u)throw Error('알 수 없는 업그레이드');if(s.upgrades[u.id]>=200)throw Error('최대 레벨이에요.');pay(cost(u.base,s.upgrades[u.id]));s.upgrades[u.id]++;message=`${u.name} 레벨 ${s.upgrades[u.id]}!`;break;}
  case 'train':{if(!unlocked(s))throw Error('업그레이드를 먼저 구매해 주세요.');const k=skills.find(x=>x.id===cmd.key);if(!k)throw Error('알 수 없는 능력');if(s.skills[k.id]>=100)throw Error('최대 레벨이에요.');pay(cost(1000,s.skills[k.id],118));s.skills[k.id]++;message=`${k.name}이 한 단계 성장했어요.`;break;}
  case 'gear':{if(!unlocked(s))throw Error('업그레이드를 먼저 구매해 주세요.');const g=equipment.find(x=>x.id===cmd.key);if(!g||s.rank<g.rank)throw Error('아직 장비 조건을 충족하지 못했어요.');if(!s.inventory.includes(g.id)){pay(BigInt(g.price));s.inventory.push(g.id);}s.equipped[g.slot]=g.id;message=`${g.name} 장착 완료`;break;}
  case 'unequip':{if(!Object.hasOwn(slots,cmd.key))throw Error('잘못된 슬롯');s.equipped[cmd.key]=null;message='장착을 해제했어요.';break;}
  case 'promote':{const p=promotion(s);if(!p.ready)throw Error('승진 조건과 평가 대기시간을 확인해 주세요.');s.nextAttempt=s.seconds+120;if(random(s,'promotion',10000)<p.chance){s.rank++;s.performance=0;s.reputation=cap(s.reputation+5,0,1000);s.failures=0;message=`축하해요! ${ranks[s.rank].name} 직급으로 승진했어요.`;log(s,message);}else{s.failures++;message=`이번 평가는 아쉬웠어요. 다음 확률 +10%p · ${s.failures}/3회 도전`;}break;}
  case 'offer':{const o=s.offers.find(x=>x.id===cmd.key);if(!o||o.expires<=s.seconds||s.rank<1)throw Error('만료된 제안이에요. 다음 채용을 기다려 주세요.');const c=companies.find(x=>x.id===o.company);if(effective(s,'expertise')<c.expertise)throw Error(`전문성 ${c.expertise}이 필요해요.`);s.company=c.id;s.negotiated=Math.min(1000,50*effective(s,'talk'));s.performance=0;s.offers=[];message=`${c.name}에서 새로운 시작!`;log(s,message);break;}
  case 'event':{if(!s.pending||s.pending.id!==cmd.key)throw Error('이미 끝난 이벤트예요.');const e=events.find(x=>x.id===s.pending.eventId);const choice=e.choices[cmd.choice];if(!choice||effective(s,'talk')<(choice.talk||0))throw Error('선택 조건을 확인해 주세요.');for(const [key,value]of Object.entries(choice.effects)){if(key==='cash')credit(s,BigInt(value)>BigInt(s.pending.rate)*300n?BigInt(s.pending.rate)*300n:BigInt(value));else s[key]=cap(s[key]+value,0,key==='stress'?100:1000);}message=choice.text;log(s,`${e.title} · ${message}`);s.pending=null;break;}
  case 'dismissOffline':s.offline=null;message='다시 만나 반가워요.';break;
  case 'settings':{if(!['sound','reducedMotion'].includes(cmd.key)||typeof cmd.value!=='boolean')throw Error('잘못된 설정');s.settings[cmd.key]=cmd.value;message='설정을 저장했어요.';break;}
  default:throw Error('지원하지 않는 요청이에요.');
 }
 s.revision++;s.receipts.push(cmd.id);s.receipts=s.receipts.slice(-1000);return {state:s,message};
}
export function validate(s){
 const fail=()=>{throw Error('저장 파일 형식이 올바르지 않거나 지원하지 않는 버전이에요.');};
 if(!s||s.version!==1||s.config!==VERSION)fail();
 const int=(v,max=1e12)=>{if(!Number.isSafeInteger(v)||v<0||v>max)fail();};
 for(const k of ['cash','earned'])if(typeof s[k]!=='string'||!/^(0|[1-9][0-9]*)$/.test(s[k])||s[k].length>31||BigInt(s[k])>MAX_MONEY)fail();
 for(const k of ['revision','seconds','xp','nextAttempt'])int(s[k]);int(s.last,Number.MAX_SAFE_INTEGER);int(s.remainder,999);int(s.xpRemainder,999);int(s.level,100);if(s.level<1)fail();int(s.rank,4);int(s.performance,1000);int(s.reputation,1000);int(s.stress,100);int(s.negotiated,1000);int(s.failures,3);
 if(!companies.some(c=>c.id===s.company))fail();
 for(const u of upgrades)int(s.upgrades?.[u.id],200);for(const k of skills)int(s.skills?.[k.id],100);
 if(!Array.isArray(s.inventory)||s.inventory.length>15||new Set(s.inventory).size!==s.inventory.length||s.inventory.some(id=>!equipment.some(g=>g.id===id)))fail();
 for(const slot of Object.keys(slots)){const id=s.equipped?.[slot];if(id!==null&&(!s.inventory.includes(id)||!equipment.some(g=>g.id===id&&g.slot===slot)))fail();}
 for(const stream of ['promotion','offers','events']){int(s.rng?.[stream],4294967295);if(!s.rng[stream])fail();}
 if(!Array.isArray(s.offers)||s.offers.length>3)fail();for(const o of s.offers){if(typeof o.id!=='string'||!companies.some(c=>c.id===o.company))fail();int(o.expires);}
 if(s.pending){if(typeof s.pending.id!=='string'||!events.some(e=>e.id===s.pending.eventId)||typeof s.pending.rate!=='string'||!/^\d{1,31}$/.test(s.pending.rate))fail();}
 if(!s.cooldowns||typeof s.cooldowns!=='object'||Array.isArray(s.cooldowns))fail();for(const [k,v]of Object.entries(s.cooldowns)){if(!events.some(e=>e.id===k))fail();int(v);}
 if(!Array.isArray(s.journal)||s.journal.length>500)fail();for(const j of s.journal){int(j.seconds);if(typeof j.text!=='string'||j.text.length>500)fail();}
 if(!s.settings||typeof s.settings.sound!=='boolean'||typeof s.settings.reducedMotion!=='boolean')fail();
 if(!Array.isArray(s.receipts)||s.receipts.length>1000||s.receipts.some(r=>typeof r!=='string'||r.length>100))fail();
 if(s.offline){int(s.offline.seconds);if(typeof s.offline.cash!=='string'||!/^\d{1,31}$/.test(s.offline.cash)||typeof s.offline.capped!=='boolean')fail();}
 return s;
}

