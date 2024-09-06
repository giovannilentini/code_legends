import{NodeProp as t}from"@lezer/common";let e=0;class Tag{constructor(t,a,i,r){this.name=t;this.set=a;this.base=i;this.modified=r;this.id=e++}toString(){let{name:t}=this;for(let e of this.modified)e.name&&(t=`${e.name}(${t})`);return t}static define(t,e){let a=typeof t=="string"?t:"?";t instanceof Tag&&(e=t);if(e===null||e===void 0?void 0:e.base)throw new Error("Can not derive from a modified tag");let i=new Tag(a,[],null,[]);i.set.push(i);if(e)for(let t of e.set)i.set.push(t);return i}static defineModifier(t){let e=new Modifier(t);return t=>t.modified.indexOf(e)>-1?t:Modifier.get(t.base||t,t.modified.concat(e).sort(((t,e)=>t.id-e.id)))}}let a=0;class Modifier{constructor(t){this.name=t;this.instances=[];this.id=a++}static get(t,e){if(!e.length)return t;let a=e[0].instances.find((a=>a.base==t&&sameArray(e,a.modified)));if(a)return a;let i=[],r=new Tag(t.name,i,t,e);for(let t of e)t.instances.push(r);let o=powerSet(e);for(let e of t.set)if(!e.modified.length)for(let t of o)i.push(Modifier.get(e,t));return r}}function sameArray(t,e){return t.length==e.length&&t.every(((t,a)=>t==e[a]))}function powerSet(t){let e=[[]];for(let a=0;a<t.length;a++)for(let i=0,r=e.length;i<r;i++)e.push(e[i].concat(t[a]));return e.sort(((t,e)=>e.length-t.length))}function styleTags(t){let e=Object.create(null);for(let a in t){let i=t[a];Array.isArray(i)||(i=[i]);for(let t of a.split(" "))if(t){let a=[],r=2,o=t;for(let e=0;;){if(o=="..."&&e>0&&e+3==t.length){r=1;break}let i=/^"(?:[^"\\]|\\.)*?"|[^\/!]+/.exec(o);if(!i)throw new RangeError("Invalid path: "+t);a.push(i[0]=="*"?"":i[0][0]=='"'?JSON.parse(i[0]):i[0]);e+=i[0].length;if(e==t.length)break;let l=t[e++];if(e==t.length&&l=="!"){r=0;break}if(l!="/")throw new RangeError("Invalid path: "+t);o=t.slice(e)}let l=a.length-1,s=a[l];if(!s)throw new RangeError("Invalid path: "+t);let n=new Rule(i,r,l>0?a.slice(0,l):null);e[s]=n.sort(e[s])}}return i.add(e)}const i=new t;class Rule{constructor(t,e,a,i){this.tags=t;this.mode=e;this.context=a;this.next=i}get opaque(){return this.mode==0}get inherit(){return this.mode==1}sort(t){if(!t||t.depth<this.depth){this.next=t;return this}t.next=this.sort(t.next);return t}get depth(){return this.context?this.context.length:0}}Rule.empty=new Rule([],2,null);function tagHighlighter(t,e){let a=Object.create(null);for(let e of t)if(Array.isArray(e.tag))for(let t of e.tag)a[t.id]=e.class;else a[e.tag.id]=e.class;let{scope:i,all:r=null}=e||{};return{style:t=>{let e=r;for(let i of t)for(let t of i.set){let i=a[t.id];if(i){e=e?e+" "+i:i;break}}return e},scope:i}}function highlightTags(t,e){let a=null;for(let i of t){let t=i.style(e);t&&(a=a?a+" "+t:t)}return a}function highlightTree(t,e,a,i=0,r=t.length){let o=new HighlightBuilder(i,Array.isArray(e)?e:[e],a);o.highlightRange(t.cursor(),i,r,"",o.highlighters);o.flush(r)}function highlightCode(t,e,a,i,r,o=0,l=t.length){let s=o;function writeTo(e,a){if(!(e<=s)){for(let o=t.slice(s,e),l=0;;){let t=o.indexOf("\n",l);let e=t<0?o.length:t;e>l&&i(o.slice(l,e),a);if(t<0)break;r();l=t+1}s=e}}highlightTree(e,a,((t,e,a)=>{writeTo(t,"");writeTo(e,a)}),o,l);writeTo(l,"")}class HighlightBuilder{constructor(t,e,a){this.at=t;this.highlighters=e;this.span=a;this.class=""}startSpan(t,e){if(e!=this.class){this.flush(t);t>this.at&&(this.at=t);this.class=e}}flush(t){t>this.at&&this.class&&this.span(this.at,t,this.class)}highlightRange(e,a,i,r,o){let{type:l,from:s,to:n}=e;if(s>=i||n<=a)return;l.isTop&&(o=this.highlighters.filter((t=>!t.scope||t.scope(l))));let h=r;let g=getStyleTags(e)||Rule.empty;let c=highlightTags(o,g.tags);if(c){h&&(h+=" ");h+=c;g.mode==1&&(r+=(r?" ":"")+c)}this.startSpan(Math.max(a,s),h);if(g.opaque)return;let f=e.tree&&e.tree.prop(t.mounted);if(f&&f.overlay){let t=e.node.enter(f.overlay[0].from+s,1);let l=this.highlighters.filter((t=>!t.scope||t.scope(f.tree.type)));let g=e.firstChild();for(let c=0,d=s;;c++){let m=c<f.overlay.length?f.overlay[c]:null;let p=m?m.from+s:n;let u=Math.max(a,d),k=Math.min(i,p);if(u<k&&g)while(e.from<k){this.highlightRange(e,u,k,r,o);this.startSpan(Math.min(k,e.to),h);if(e.to>=p||!e.nextSibling())break}if(!m||p>i)break;d=m.to+s;if(d>a){this.highlightRange(t.cursor(),Math.max(a,m.from+s),Math.min(i,d),"",l);this.startSpan(Math.min(i,d),h)}}g&&e.parent()}else if(e.firstChild()){f&&(r="");do{if(!(e.to<=a)){if(e.from>=i)break;this.highlightRange(e,a,i,r,o);this.startSpan(Math.min(i,e.to),h)}}while(e.nextSibling());e.parent()}}}function getStyleTags(t){let e=t.type.prop(i);while(e&&e.context&&!t.matchContext(e.context))e=e.next;return e||null}const r=Tag.define;const o=r(),l=r(),s=r(l),n=r(l),h=r(),g=r(h),c=r(h),f=r(),d=r(f),m=r(),p=r(),u=r(),k=r(u),y=r();const b={comment:o,lineComment:r(o),blockComment:r(o),docComment:r(o),name:l,variableName:r(l),typeName:s,tagName:r(s),propertyName:n,attributeName:r(n),className:r(l),labelName:r(l),namespace:r(l),macroName:r(l),literal:h,string:g,docString:r(g),character:r(g),attributeValue:r(g),number:c,integer:r(c),float:r(c),bool:r(h),regexp:r(h),escape:r(h),color:r(h),url:r(h),keyword:m,self:r(m),null:r(m),atom:r(m),unit:r(m),modifier:r(m),operatorKeyword:r(m),controlKeyword:r(m),definitionKeyword:r(m),moduleKeyword:r(m),operator:p,derefOperator:r(p),arithmeticOperator:r(p),logicOperator:r(p),bitwiseOperator:r(p),compareOperator:r(p),updateOperator:r(p),definitionOperator:r(p),typeOperator:r(p),controlOperator:r(p),punctuation:u,separator:r(u),bracket:k,angleBracket:r(k),squareBracket:r(k),paren:r(k),brace:r(k),content:f,heading:d,heading1:r(d),heading2:r(d),heading3:r(d),heading4:r(d),heading5:r(d),heading6:r(d),contentSeparator:r(f),list:r(f),quote:r(f),emphasis:r(f),strong:r(f),link:r(f),monospace:r(f),strikethrough:r(f),inserted:r(),deleted:r(),changed:r(),invalid:r(),meta:y,documentMeta:r(y),annotation:r(y),processingInstruction:r(y),definition:Tag.defineModifier("definition"),constant:Tag.defineModifier("constant"),function:Tag.defineModifier("function"),standard:Tag.defineModifier("standard"),local:Tag.defineModifier("local"),special:Tag.defineModifier("special")};for(let t in b){let e=b[t];e instanceof Tag&&(e.name=t)}const w=tagHighlighter([{tag:b.link,class:"tok-link"},{tag:b.heading,class:"tok-heading"},{tag:b.emphasis,class:"tok-emphasis"},{tag:b.strong,class:"tok-strong"},{tag:b.keyword,class:"tok-keyword"},{tag:b.atom,class:"tok-atom"},{tag:b.bool,class:"tok-bool"},{tag:b.url,class:"tok-url"},{tag:b.labelName,class:"tok-labelName"},{tag:b.inserted,class:"tok-inserted"},{tag:b.deleted,class:"tok-deleted"},{tag:b.literal,class:"tok-literal"},{tag:b.string,class:"tok-string"},{tag:b.number,class:"tok-number"},{tag:[b.regexp,b.escape,b.special(b.string)],class:"tok-string2"},{tag:b.variableName,class:"tok-variableName"},{tag:b.local(b.variableName),class:"tok-variableName tok-local"},{tag:b.definition(b.variableName),class:"tok-variableName tok-definition"},{tag:b.special(b.variableName),class:"tok-variableName2"},{tag:b.definition(b.propertyName),class:"tok-propertyName tok-definition"},{tag:b.typeName,class:"tok-typeName"},{tag:b.namespace,class:"tok-namespace"},{tag:b.className,class:"tok-className"},{tag:b.macroName,class:"tok-macroName"},{tag:b.propertyName,class:"tok-propertyName"},{tag:b.operator,class:"tok-operator"},{tag:b.comment,class:"tok-comment"},{tag:b.meta,class:"tok-meta"},{tag:b.invalid,class:"tok-invalid"},{tag:b.punctuation,class:"tok-punctuation"}]);export{Tag,w as classHighlighter,getStyleTags,highlightCode,highlightTree,styleTags,tagHighlighter,b as tags};

