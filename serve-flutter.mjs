import http from 'node:http';
import {readFile} from 'node:fs/promises';
import {fileURLToPath} from 'node:url';
import path from 'node:path';
const root=fileURLToPath(new URL('./build/web/',import.meta.url));
const types={'.html':'text/html; charset=utf-8','.js':'text/javascript','.wasm':'application/wasm','.json':'application/json','.png':'image/png','.ttf':'font/ttf','.css':'text/css'};
http.createServer(async(req,res)=>{
  try {
    const name=decodeURIComponent(new URL(req.url,'http://localhost').pathname);
    const file=path.resolve(root,'.'+(name==='/'?'/index.html':name));
    if(!file.startsWith(root)||name.includes('..')) throw Error('Invalid path');
    const data=await readFile(file);
    res.writeHead(200,{'Content-Type':types[path.extname(file)]||'application/octet-stream','Cache-Control':'no-cache','Cross-Origin-Opener-Policy':'same-origin','Cross-Origin-Embedder-Policy':'require-corp','X-Content-Type-Options':'nosniff'});
    res.end(data);
  } catch {res.writeHead(404);res.end('Not found. Run flutter build web first.');}
}).listen(4174,'127.0.0.1',()=>console.log('Flutter game: http://127.0.0.1:4174'));
