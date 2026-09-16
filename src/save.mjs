import {validate} from './engine.mjs';
export function canonical(v){if(Array.isArray(v))return '['+v.map(canonical).join(',')+']';if(v&&typeof v==='object')return '{'+Object.keys(v).sort().map(k=>JSON.stringify(k)+':'+canonical(v[k])).join(',')+'}';return JSON.stringify(v);}
export async function envelope(state){validate(state);const payload=canonical(state);const bytes=await crypto.subtle.digest('SHA-256',new TextEncoder().encode(payload));return {payload,checksum:Array.from(new Uint8Array(bytes),v=>v.toString(16).padStart(2,'0')).join('')};}
export async function decode(e){if(!e||typeof e.payload!=='string'||e.payload.length>5*1024*1024)throw Error('저장 파일을 읽을 수 없어요.');const state=validate(JSON.parse(e.payload));if((await envelope(state)).checksum!==e.checksum)throw Error('저장 파일 검증에 실패했어요.');return state;}
export class SaveRepository{
 constructor(name='office-worker-slice'){this.name=name;}
 async open(){this.db=await new Promise((resolve,reject)=>{const r=indexedDB.open(this.name,1);r.onupgradeneeded=()=>r.result.createObjectStore('saves');r.onsuccess=()=>resolve(r.result);r.onerror=()=>reject(r.error);r.onblocked=()=>reject(Error('다른 게임 창을 닫고 다시 시도해 주세요.'));});}
 async raw(){return new Promise((resolve,reject)=>{const r=this.db.transaction('saves').objectStore('saves').get('profile');r.onsuccess=()=>resolve(r.result);r.onerror=()=>reject(r.error);r.onblocked=()=>reject(Error('다른 게임 창을 닫고 다시 시도해 주세요.'));});}
 async load(){const raw=await this.raw();if(!raw)return {state:null,revision:0};try{const state=await decode(raw.current);this.lastEnvelope=raw.current;return {state,revision:raw.revision};}catch(error){try{const state=await decode(raw.previous);this.lastEnvelope=raw.previous;return {state,revision:raw.revision,recovered:true};}catch{throw error;}}}
 async commit(state,expected){const next=structuredClone(state);next.revision=expected+1;const current=await envelope(next);return new Promise((resolve,reject)=>{const tx=this.db.transaction('saves','readwrite');const store=tx.objectStore('saves');const request=store.get('profile');let failure;request.onsuccess=()=>{const old=request.result;if((old?.revision||0)!==expected){failure=Error('다른 창에서 저장이 갱신됐어요. 새로고침 후 이어가 주세요.');tx.abort();return;}store.put({current,previous:this.lastEnvelope||old?.current||current,revision:next.revision},'profile');};tx.oncomplete=()=>{this.lastEnvelope=current;resolve(next);};tx.onerror=()=>reject(failure||tx.error);tx.onabort=()=>reject(failure||tx.error||Error('저장하지 못했어요.'));});}
 async reset(){return new Promise((resolve,reject)=>{const tx=this.db.transaction('saves','readwrite');tx.objectStore('saves').delete('profile');tx.oncomplete=resolve;tx.onerror=()=>reject(tx.error);});}
}


