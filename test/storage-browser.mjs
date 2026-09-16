import {SaveRepository,decode} from '../src/save.mjs';
import {fresh,advance} from '../src/engine.mjs';
const output=document.querySelector('#results');const lines=[];
const check=(ok,label)=>{if(!ok)throw Error(label);lines.push('PASS '+label);output.textContent=lines.join('\n');};
const name='office-worker-isolated-test-'+crypto.randomUUID();
const repo=new SaveRepository(name);
async function replace(raw){await new Promise((resolve,reject)=>{const tx=repo.db.transaction('saves','readwrite');tx.objectStore('saves').put(raw,'profile');tx.oncomplete=resolve;tx.onerror=()=>reject(tx.error);});}
try{
 await repo.open();check((await repo.load()).state===null,'Empty database returns no profile');
 let s=await repo.commit(fresh(1000000,1),0);s=await repo.commit(advance(s,60),s.revision);
 check((await repo.load()).state.cash==='6000','Actual IndexedDB commit/load round trip');
 const raw=await repo.raw();check((await decode(raw.previous)).cash==='0','Previous snapshot retained atomically');
 let rejected=false;try{await repo.commit(advance(s,60),0);}catch{rejected=true;}
 check(rejected&&(await repo.load()).state.cash==='6000','Stale writer rejected without modifying committed data');
 raw.current.checksum='corrupt';await replace(raw);const recovered=await repo.load();
 check(recovered.recovered&&recovered.state.cash==='0','Corrupt current save recovers previous valid snapshot');
 await repo.commit(recovered.state,recovered.revision);
 check((await decode((await repo.raw()).previous)).cash==='0','Recovery commit preserves a valid backup');
 const broken=await repo.raw();broken.current.checksum='broken';broken.previous.checksum='also broken';await replace(broken);
 rejected=false;try{await repo.load();}catch{rejected=true;}
 check(rejected&&JSON.stringify(await repo.raw())===JSON.stringify(broken),'Double corruption is rejected without overwriting evidence');
 output.textContent=lines.join('\n')+'\n\n7/7 browser storage tests passed.';
}catch(e){output.textContent=lines.join('\n')+'\nFAIL '+e.message;}finally{repo.db?.close();indexedDB.deleteDatabase(name);}
