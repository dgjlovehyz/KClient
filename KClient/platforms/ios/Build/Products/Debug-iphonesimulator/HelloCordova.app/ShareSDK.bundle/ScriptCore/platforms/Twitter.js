var $pluginID="com.mob.sharesdk.Twitter";eval(function(p,a,c,k,e,r){e=function(c){return(c<62?'':e(parseInt(c/62)))+((c=c%62)>35?String.fromCharCode(c+29):c.toString(36))};if('0'.replace(0,e)==0){while(c--)r[e(c)]=k[c];k=[function(e){return r[e]||e}];e=function(){return'([35-9a-fhj-mo-zA-Z]|[1-3]\\w)'};c=1};while(c--)if(k[c])p=p.replace(new RegExp('\\b'+e(c)+'\\b','g'),k[c]);return p}('8 s={"11":"consumer_key","12":"consumer_secret","13":"redirect_uri","1l":"covert_url"};a h(m){6.1m=3;6.1R=3;6.2u=m;6.o={"B":3,"C":3};6.14=3}h.k.m=a(){q 6.2u};h.k.Q=a(){q"h"};h.k.R=a(){7(6.o["C"]!=3&&6.o["C"][s.11]!=3){q 6.o["C"][s.11]}l 7(6.o["B"]!=3&&6.o["B"][s.11]!=3){q 6.o["B"][s.11]}q 3};h.k.15=a(){7(6.o["C"]!=3&&6.o["C"][s.12]!=3){q 6.o["C"][s.12]}l 7(6.o["B"]!=3&&6.o["B"][s.12]!=3){q 6.o["B"][s.12]}q 3};h.k.1a=a(){7(6.o["C"]!=3&&6.o["C"][s.13]!=3){q 6.o["C"][s.13]}l 7(6.o["B"]!=3&&6.o["B"][s.13]!=3){q 6.o["B"][s.13]}q 3};h.k.1S=a(){q"2v-2w-"+$5.9.16.h+"-"+6.R()};h.k.1T=a(){7(6.o["C"]!=3&&6.o["C"][s.1l]!=3){q 6.o["C"][s.1l]}l 7(6.o["B"]!=3&&6.o["B"][s.1l]!=3){q 6.o["B"][s.1l]}q $5.9.1T()};h.k.2x=a(1b){7(2y.U==0){q 6.o["B"]}l{6.o["B"]=6.1U(1b)}};h.k.2z=a(1b){7(2y.U==0){q 6.o["C"]}l{6.o["C"]=6.1U(1b)}};h.k.saveConfig=a(){8 e=6;8 17="2v-2w";$5.V.2A("2B",1n,17,a(c){7(c!=3){8 1o=c.1b;7(1o==3){1o={}}1o["plat_"+e.m()]=e.R();$5.V.2C("2B",1o,1n,17,3)}})};h.k.isSupportAuth=a(){q 2D};h.k.2E=a(v,settings){8 p=3;8 e=6;7(6.2F()){8 y="M://W.N.O/1V/request_token";8 18={"1W":6.R(),"1X":"1Y-1Z","20":1c(1x 1y().1z()/21).X(),"22":1c(23.24()*25).X(),"26":"1.0"};$5.V.27(6.m(),3,y,"1A",3,3,18,6.15(),3,a(c){7(c!=3){7(c["D"]!=3){$5.H.P(v,$5.9.t.F,p)}l{8 E=$5.u.28($5.u.1p(c["1q"]));7(c["29"]==2a&&E==3){E=$5.u.2b($5.u.1p(c["1q"]));e.1m=E["1d"];e.1R=E["2G"];8 2H="M://W.N.O/1V/2E?1d="+e.1m;$5.H.ssdk_openAuthUrl(v,2H,e.1a())}l{p={"D":$5.9.I.1e,"2c":E};$5.H.P(v,$5.9.t.F,p)}}}l{p={"D":$5.9.I.1e,"19":"分享平台["+e.Q()+"]请求授权失败!"};$5.H.P(v,$5.9.t.F,p)}})}l{p={"D":$5.9.I.InvaildPlatform,"19":"分享平台［"+6.Q()+"］应用信息无效!"};$5.H.P(v,$5.9.t.F,p)}};h.k.handleAuthCallback=a(v,1B){8 p=3;8 e=6;8 1C=$5.u.parseUrl(1B);7(1C!=3&&1C.Y!=3){8 f=$5.u.2b(1C.Y);7(f!=3){e.1m=f["1d"];8 2I=f["2J"];8 y="M://W.N.O/1V/access_token";8 18={"1W":e.R(),"1d":e.1m,"1X":"1Y-1Z","20":1c(1x 1y().1z()/21).X(),"22":1c(23.24()*25).X(),"26":"1.0","oauth_callback":e.1a(),"2J":2I};$5.V.27(e.m(),3,y,"2d",3,3,18,e.15(),e.1R,a(c){7(c!=3){7(c["D"]!=3){$5.H.P(v,$5.9.t.F,p)}l{8 E=$5.u.28($5.u.1p(c["1q"]));7(c["29"]==2a&&E==3){E=$5.u.2b($5.u.1p(c["1q"]));e.2K(v,E)}l{p={"D":$5.9.I.1e,"2c":E};$5.H.P(v,$5.9.t.F,p)}}}l{p={"D":$5.9.I.1e,"19":"分享平台["+e.Q()+"]请求授权失败!"};$5.H.P(v,$5.9.t.F,p)}})}l{p={"D":$5.9.I.2L,"19":"无效的授权回调:["+1B+"]"};$5.H.P(v,$5.9.t.F,p)}}l{p={"D":$5.9.I.2L,"19":"无效的授权回调:["+1B+"]"};$5.H.P(v,$5.9.t.F,p)}};h.k.2M=a(Y,d){8 e=6;6.1f(a(b){8 f={};7(Y!=3){7(Y.J!=3){f["1D"]=Y.J}l 7(Y.Q!=3){f["1r"]=Y.Q}}l 7(b!=3&&b.z!=3&&b.z.J!=3){f["1D"]=b.z.J}e.1g("M://W.N.O/1.1/1h/show.1i","2d",f,a(A,c){8 r=c;7(A==$5.9.t.Z){r={"1s":$5.9.16.h};e.1t(r,c);7(r["J"]==b["J"]){r["z"]=b["z"]}}7(d!=3){d(A,r)}})})};h.k.1g=a(y,2N,f,d){8 p=3;8 e=6;6.1f(a(b){7(b!=3){7(f==3){f={}}8 18={};8 2e=3;7(b.z!=3){18={"1W":e.R(),"1d":b.z.2f,"1X":"1Y-1Z","20":1c(1x 1y().1z()/21).X(),"22":1c(23.24()*25).X(),"26":"1.0"};2e=b.z.2g}$5.V.27($5.9.16.h,3,y,2N,f,3,18,e.15(),2e,a(c){7(c!=3){7(c["D"]!=3){7(d){d($5.9.t.F,c)}}l{8 E=$5.u.28($5.u.1p(c["1q"]));7(c["29"]==2a){7(d){d($5.9.t.Z,E)}}l{8 2h=$5.9.I.1e;2O(E["D"]){1E 89:1E 215:2h=$5.9.I.2P;2i}p={"D":2h,"2c":E};7(d){d($5.9.t.F,p)}}}}l{p={"D":$5.9.I.1e};7(d){d($5.9.t.F,p)}}})}l{p={"D":$5.9.I.2P,"19":"尚未授权["+e.Q()+"]用户"};7(d){d($5.9.t.F,p)}}})};h.k.cancelAuthorize=a(){6.1F(3,3)};h.k.addFriend=a(v,b,d){8 f={};7(b["J"]!=3){f["1D"]=b["J"]}l 7(b["2j"]!=3){f["1r"]=b["2j"]}8 e=6;6.1g("M://W.N.O/1.1/friendships/create.1i","1A",f,a(A,c){8 r=c;7(A==$5.9.t.Z){r={"1s":$5.9.16.h};e.1t(r,c)}7(d!=3){d(A,r)}})};h.k.getFriends=a(2k,2Q,d){8 e=6;6.1f(a(b){8 f={"b":b.J,"2k":2k,"count":2Q};e.1g("M://W.N.O/1.1/friends/list.1i","2d",f,a(A,c){8 r=c;7(A==$5.9.t.Z){r={};r["prev_cursor"]=c["previous_cursor"];r["2l"]=c["2l"];8 1h=[];8 1G=c["1h"];7(1G!=3){2R(8 i=0;i<1G.U;i++){8 b={"1s":$5.9.16.h};e.1t(b,1G[i]);1h.2S(b)}}r["1h"]=1h;r["has_next"]=c["2l"]>0}7(d!=3){d(A,r)}})})};h.k.share=a(v,G,d){8 K=3;8 L=3;8 1j=3;8 1H=G!=3?G["@1H"]:3;8 1u={"@1H":1H};8 m=$5.9.S(6.m(),G,"m");7(m==3){m=$5.9.1k.2T}7(m==$5.9.1k.2T){m=6.2U(G)}8 y=3;8 f=3;2O(m){1E $5.9.1k.2V:{K=$5.9.S(6.m(),G,"K");7(K!=3){y="M://W.N.O/1.1/2W/2X.1i";f={"1I":K};L=$5.9.S(6.m(),G,"L");1j=$5.9.S(6.m(),G,"1v");7(L!=3&&1j!=3){f["L"]=L;f["1v"]=1j}}2i}1E $5.9.1k.2Y:{8 j=$5.9.S(6.m(),G,"j");7(j!=3){7(j.U>4){j.2m(4)}y="M://W.N.O/1.1/2W/2X.1i";f={"j":j};K=$5.9.S(6.m(),G,"K");7(K!=3){f["1I"]=K}L=$5.9.S(6.m(),G,"L");8 1v=$5.9.S(6.m(),G,"1v");7(L!=3&&1j!=3){f["L"]=L;f["1v"]=1j}}2i}}7(y!=3&&f!=3){6.2Z(y,f,1u,d)}l{8 p={"D":$5.9.I.UnsupportContentType,"19":"不支持的分享类型["+m+"]"};7(d!=3){d($5.9.t.F,p,3,1u)}}};h.k.createUserByRawData=a(w){8 b={"1s":6.m()};6.1t(b,w);q $5.u.1J(b)};h.k.30=a(2n,d){7(6.1T()){8 e=6;6.1f(a(b){$5.9.convertUrl(e.m(),b,2n,d)})}l{7(d){d({"1K":2n})}}};h.k._isUserAvaliable=a(b){q b.z!=3&&b.z.2f!=3&&b.z.2g!=3};h.k.2F=a(){7(6.R()!=3&&6.15()!=3&&6.1a()!=3){q 2D}$5.H.log("#warning:["+6.Q()+"]应用信息有误，不能进行相关操作。请检查本地代码中和服务端的["+6.Q()+"]平台应用配置是否有误! \\n本地配置:"+$5.u.1J(6.2x())+"\\n服务器配置:"+$5.u.1J(6.2z()));q 1n};h.k.1U=a(10){8 R=$5.u.2o(10[s.11]);8 15=$5.u.2o(10[s.12]);8 1a=$5.u.2o(10[s.13]);10[s.11]=R;10[s.12]=15;10[s.13]=1a;q 10};h.k.2K=a(v,1w){8 e=6;8 z={"J":1w["1D"],"2f":1w["1d"],"2g":1w["2G"],"2p":1w,"m":$5.9.credentialType.OAuth1x};8 b={"1s":$5.9.16.h,"z":z};6.1F(b,a(){e.2M(3,a(A,c){7(A==$5.9.t.Z){c["z"]=b["z"];b=c;e.1F(b,3)}$5.H.P(v,$5.9.t.Z,b)})})};h.k.1F=a(b,d){6.14=b;8 17=6.1S();$5.V.2C("31",6.14,1n,17,a(c){7(d!=3){d()}})};h.k.1f=a(d){7(6.14!=3){7(d){d(6.14)}}l{8 e=6;8 17=6.1S();$5.V.2A("31",1n,17,a(c){e.14=c!=3?c.1b:3;7(d){d(e.14)}})}};h.k.1t=a(b,w){7(b!=3&&w!=3){b["2p"]=w;b["J"]=w["32"];b["2j"]=w["1r"];b["icon"]=w["profile_image_url"];b["gender"]=2;7(w["1r"]!=3){b["y"]="M://N.O/"+w["1r"]}b["about_me"]=w["description"];b["verify_type"]=w["verified"]?1:0;b["follower_count"]=w["followers_count"];b["friend_count"]=w["friends_count"];b["share_count"]=w["statuses_count"];7(w["33"]!=3){8 34=1x 1y(w["33"]);b["reg_at"]=34.1z()}}};h.k.2Z=a(y,f,1u,d){8 e=6;6.1f(a(b){e.30([f["1I"]],a(c){f["1I"]=c.1K[0];e.35(f,a(f){e.1g(y,"1A",f,a(A,c){8 r=c;7(A==$5.9.t.Z){r={};r["2p"]=c;r["cid"]=c["32"];r["K"]=c["K"];7(c["2q"]!=3&&c["2q"]["1L"]!=3){8 1M=c["2q"]["1L"];7(36.k.X.37(1M)===\'[38 39]\'){8 j=[];2R(8 i=0;i<1M.U;i++){8 2r=1M[i];7(2r["m"]=="photo"){j.2S(2r["media_url"])}}r["j"]=j}}}7(d!=3){d(A,r,b,1u)}})})})})};h.k.35=a(f,d){8 e=6;7(f["j"]!=3){6.1N(f["j"],0,a(j){e.1O(j,0,a(j){7(j.U>0){f["media_ids"]=j.join(",")}delete f["j"];f["j"]=3;7(d){d(f)}})})}l{7(d){d(f)}}};h.k.1N=a(j,x,d){8 e=6;7(x<j.U){8 T=j[x];7(!/^(1P\\:\\/)?\\//.2s(T)){$5.V.downloadFile(T,a(c){7(c.1K!=3){j[x]=c.1K;x++}l{j.2m(x,1)}e.1N(j,x,d)})}l{x++;6.1N(j,x,d)}}l{7(d){d(j)}}};h.k.1O=a(j,x,d){7(x<j.U){8 2t=3;8 e=6;8 y="M://3a.N.O/1.1/1L/3a.1i";8 T=j[x];8 1Q="application/octet-stream";7(/\\.jpe?g$/.2s(T)){1Q="T/jpeg"}l 7(/\\.3b$/.2s(T)){1Q="T/3b"}8 1P={"path":T,"mime_type":1Q};f={"1L":"@1P("+$5.u.1J(1P)+")"};6.1g(y,"1A",f,a(A,c){7(A==$5.9.t.Z){2t=c["media_id_string"];j[x]=2t;x++;e.1O(j,x,d)}l{j.2m(x,1);e.1O(j,x,d)}})}l{7(d){d(j)}}};h.k.2U=a(G){8 m=$5.9.1k.2V;8 j=$5.9.S(6.m(),G,"j");7(36.k.X.37(j)===\'[38 39]\'){m=$5.9.1k.2Y}q m};$5.9.registerPlatformClass($5.9.16.h,h);',[],198,'|||null||mob|this|if|var|shareSDK|function|user|data|callback|self|params||Twitter||images|prototype|else|type||_appInfo|error|return|resultData|TwitterAppInfoKeys|responseState|utils|sessionId|rawData|index|url|credential|state|local|server|error_code|response|Fail|parameters|native|errorCode|uid|text|lat|https|twitter|com|ssdk_authStateChanged|name|consumerKey|getShareParam|image|length|ext|api|toString|query|Success|appInfo|ConsumerKey|ConsumerSecret|RedirectUri|_currentUser|consumerSecret|platformType|domain|oauthParams|error_message|redirectUri|value|parseInt|oauth_token|APIRequestFail|_getCurrentUser|callApi|users|json|lng|contentType|ConvertUrl|_oauthToken|false|curApps|base64Decode|response_data|screen_name|platform_type|_updateUserInfo|userData|long|credentialRawData|new|Date|getTime|POST|callbackUrl|urlInfo|user_id|case|_setCurrentUser|rawUsersData|flags|status|objectToJsonString|result|media|medias|_downloadWebImage|_uploadImage|file|mimeType|_oauthTokenSecret|cacheDomain|convertUrlEnabled|_checkAppInfoAvailable|oauth|oauth_consumer_key|oauth_signature_method|HMAC|SHA1|oauth_timestamp|1000|oauth_nonce|Math|random|100000|oauth_version|ssdk_callOAuthApi|jsonStringToObject|status_code|200|parseUrlParameters|user_data|GET|oauthTokenSecret|token|secret|code|break|nickname|cursor|next_cursor|splice|contents|trim|raw_data|entities|item|test|mediaId|_type|SSDK|Platform|localAppInfo|arguments|serverAppInfo|getCacheData|currentApp|setCacheData|true|authorize|_isAvailable|oauth_token_secret|authUrl|oauthVerifier|oauth_verifier|_succeedAuthorize|InvalidAuthCallback|getUserInfo|method|switch|UserUnauth|size|for|push|Auto|_getShareType|Text|statuses|update|Image|_share|_convertUrl|currentUser|id_str|created_at|date|_convertShareParams|Object|apply|object|Array|upload|png'.split('|'),0,{}))