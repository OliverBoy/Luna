class com.hypeCP.loader.loader
{
    var PLUGIN_HOLDER, loadSWFb, CLIENT, onEnterFrame;
    function loader(arg)
    {
        HANDLERS.SHELL = {};
        HANDLERS.AIRTOWER = {};
        HANDLERS.LOCAL_CRUMBS = {};
        HANDLERS.GLOBAL_CRUMBS = {};
        HANDLERS.ENGINE = {};
        HANDLERS.INTERFACE = {};
        this._addReplace(function (url)
        {
            return (url);
        });
        _global.baseURL = "http://localhost/";
        System.security.allowDomain("*");
        loadMovieNum("http://localhost/play/v2/client/load.swf?cp1356", 1);
        _root.onEnterFrame = function ()
        {
            for (var _loc11 in _level1)
            {
                if (typeof(_level1[_loc11]) == "movieclip")
                {
                    _level1.bootLoader.messageFromAS3({type: "setEnvironmentData", data: {clientPath: "http://localhost/play/v2/client/", contentPath: "http://localhost/play/v2/content/", gamesPath: "http://localhost/play/v2/games/", connectionID: "hype127", language: "en", basePath: "", affiliateID: "0"}});
                    _root.onEnterFrame = function ()
                    {
                        if (_level1.shellContainer.DEPENDENCIES_FILENAME)
                        {
                            _level1.bootLoader.messageFromAS3({type: "showLogin"});
                            _level0.CLIENT.handleContainerFound(_level0.CLIENT.PENGUIN = _level1.shellContainer);
                        } // end if
                    };
                } // end if
            } // end of for...in
        };
    } // End of the function
    function handlePluginLoaded(pluginFunction, inter)
    {
        if (PENGUIN.AIRTOWER && (!inter || PENGUIN.INTERFACE))
        {
            pluginFunction();
        }
        else
        {
            PLUGINS.push([pluginFunction, inter]);
        } // end else if
    } // End of the function
    function handleContainerFound(container)
    {
        this.PLUGIN_HOLDER = this.PENGUIN.createEmptyMovieClip("pluginContainer_mc", 65535);
        _global.PenguBackup = container;
        with (container)
        {
            if (LOCAL_CRUMBS)
            {
                _level0.CLIENT._fireEvent("LOCAL_CRUMBS");
            } // end if
            if (GLOBAL_CRUMBS)
            {
                _level0.CLIENT._fireEvent("GLOBAL_CRUMBS");
            } // end if
            if (AIRTOWER)
            {
                _level0.CLIENT._fireEvent("AIRTOWER");
            } // end if
            if (SHELL)
            {
                _level0.CLIENT._fireEvent("SHELL");
            } // end if
            if (!LOCAL_CRUMBS)
            {
                return;
            } // end if
            for (var i in this.FAKE_LANG)
            {
                LOCAL_CRUMBS.lang[i] = this.FAKE_LANG[i];
            } // end of for...in
            if (!GLOBAL_CRUMBS || !AIRTOWER || !SHELL)
            {
                return;
            } // end if
            createEmptyMovieClip("addons_mc", _level1.getNextHighestDepth());
            SHELL.analytics = false;
            SHELL.hideErrorPrompt();
            GLOBAL_CRUMBS.login_server.ip = [this.HOST];
            GLOBAL_CRUMBS.login_server.even_port = 6112;
            GLOBAL_CRUMBS.login_server.odd_port = 6112;
            GLOBAL_CRUMBS.redemption_server.ip = this.HOST;
            GLOBAL_CRUMBS.redemption_server.port = 6114;
            AIRTOWER.LOGIN_IP = this.HOST;
            AIRTOWER.LOGIN_PORT_EVEN = 6112;
            AIRTOWER.LOGIN_PORT_ODD = 6112;
			AIRTOWER.SET_SIZE = "ssp";
            AIRTOWER.SET_ALPHA = "ssa";
            AIRTOWER.SET_BLEND = "ssb";
            AIRTOWER.PLUGIN_LOAD = "pl";
            AIRTOWER.SERVER_DATA = "sd";
            AIRTOWER.GET_VERSION = "gv";
            AIRTOWER.GET_SERVERS = "gs";
            AIRTOWER.MOD_REQUEST = "xy";
            AIRTOWER.SWF_COMMAND = "fc";
            AIRTOWER.UPDATE_MOOD = "umo";
            AIRTOWER.PRIVATE_MSG = "pmsg";
            AIRTOWER.GET_USERLOG = "glog";
            AIRTOWER.NEW_USERLOG = "nlog";
            AIRTOWER.TIMER_KICK = "tk";
            AIRTOWER.LOAD_MOVIE = "lm";
            SHELL.e_func[SHELL.KICK] = function ()
            {
                trace ("Kicked");
            };
			AIRTOWER.addListener(AIRTOWER.SET_SIZE, this.handleSetSize);
            AIRTOWER.addListener(AIRTOWER.SET_BLEND, this.handleSetBlend);
            AIRTOWER.addListener(AIRTOWER.SET_ALPHA, this.handleSetAlpha);
            AIRTOWER.addListener(AIRTOWER.PLUGIN_LOAD, this.handlePluginLoad);
            AIRTOWER.addListener(AIRTOWER.SERVER_DATA, this.handleServerData);
            AIRTOWER.addListener(AIRTOWER.GET_VERSION, this.handleGetVersion);
            AIRTOWER.addListener(AIRTOWER.GET_SERVERS, this.handleServers);
            AIRTOWER.addListener(AIRTOWER.MOD_REQUEST, this.handleModRequest);
            AIRTOWER.addListener(AIRTOWER.SWF_COMMAND, this.handleSwfCommand);
            AIRTOWER.addListener(AIRTOWER.UPDATE_MOOD, this.handleUpdateMood);
            AIRTOWER.addListener(AIRTOWER.PRIVATE_MSG, this.handlePrivateMsg);
            AIRTOWER.addListener(AIRTOWER.TIMER_KICK, this.handleTimerKick);
            AIRTOWER.addListener(AIRTOWER.LOAD_MOVIE, this.handleLoadMovie);
            AIRTOWER.addListener(AIRTOWER.GET_USERLOG, this.bakeHandler(AIRTOWER.GET_USERLOG));
            AIRTOWER.addListener(AIRTOWER.NEW_USERLOG, this.bakeHandler(AIRTOWER.NEW_USERLOG));
            GLOBAL_CRUMBS.mascots_crumbs = new Object();
            GLOBAL_CRUMBS.mascots_crumbs[1] = {name: "Lynx", gift_id: 9056};
            SHELL.redemption_server.ip = this.HOST;
            SHELL.redemption_server.port = 6114;
            SHELL.createEmptyMovieClip("core_mc", SHELL.getNextHighestDepth());
            SHELL.loadSWFb = SHELL.loadSWF;
            SHELL.loadSWF = function (a, b, c, d, e, f)
            {
                for (var _loc3 in _level0.CLIENT.REPLACES)
                {
                    b = _level0.CLIENT.REPLACES[_loc3](b);
                } // end of for...in
                return (this.loadSWFb(a, b, c, d, e, f));
            };
            SHELL.makePlayerObjectFromStringB = SHELL.makePlayerObjectFromString;
            SHELL.makePlayerObjectFromString = function (str)
            {
                var _loc1 = SHELL.makePlayerObjectFromStringB(str);
                _loc1.data = str.split("|");
                return (_loc1);
            };
            LOCAL_CRUMBS.lang.chat_restrict = "a-z A-Z z-A 0-9 !-} ?!.,;:`´-_/\\(){}=&$§\"=?@\'*+-ßäöüÄÖÜ#?<>\n\t";
        } // End of with
        System.security.allowDomain.call(_level1, "*");
        for (var i in this.PLUGINS)
        {
            if (!this.PLUGINS[i][1])
            {
                this.PLUGINS[i][0]();
            } // end if
        } // end of for...in
        _root.onEnterFrame = this.waitForInterface;
    } // End of the function
	
	 function handleSetSize(obj)
    {
        var _loc1 = obj.shift();
        var _loc3 = obj.shift();
        var _loc4 = obj.shift();
        _level0.CLIENT.PENGUIN.ENGINE.room_mc.load_mc.p(_loc1)._XSCALE = _loc3;
        var _loc2 = "ENGINE.room_mc.load_mc.p" + _loc1 + "._XSCALE";
        _level0.CLIENT._setProperty(_loc2.split("."), _loc3);
        _loc2 = "ENGINE.room_mc.load_mc.p" + _loc1 + "._YSCALE";
        _level0.CLIENT._setProperty(_loc2.split("."), _loc4);
        trace (_loc1);
        trace (_loc3);
        trace (_loc4);
    } // End of the function
    function handleSetAlpha(obj)
    {
        var _loc1 = obj.shift();
        var _loc2 = obj.shift();
        var _loc3 = "ENGINE.room_mc.load_mc.p" + _loc1 + "._alpha";
        _level0.CLIENT._setProperty(_loc3.split("."), _loc2);
        trace (_loc1);
        trace (_loc2);
    } // End of the function
    function handleSetBlend(obj)
    {
        var _loc1 = obj.shift();
        var _loc2 = obj.shift();
        var _loc3 = "ENGINE.room_mc.load_mc.p" + _loc1 + ".blendMode";
        _level0.CLIENT._setProperty(_loc3.split("."), _loc2);
        trace (_loc1);
        trace (_loc2);
    } // End of the function
	
    function handleServers(obj)
    {
        trace ("Handling Servers");
        for (var _loc3 in _level0.CLIENT.PENGUIN.GLOBAL_CRUMBS.servers)
        {
            delete _level0.CLIENT.PENGUIN.GLOBAL_CRUMBS.servers[_loc3];
            delete _level0.CLIENT.PENGUIN.SHELL.world_crumbs[_loc3];
        } // end of for...in
        var _loc2 = obj[1].split("|");
        for (var _loc3 in _loc2)
        {
            _loc3 = _loc2[_loc3];
            var _loc1 = _loc3.split(":");
            _level0.CLIENT.addServer(_loc1[2], _loc1[0], _loc1[1], _loc1[3]);
        } // end of for...in
    } // End of the function
    function addServer(name, ip, port, population)
    {
        var _loc1 = 0;
        for (var _loc2 in _level0.CLIENT.PENGUIN.GLOBAL_CRUMBS.servers)
        {
            ++_loc1;
        } // end of for...in
        ++_loc1;
        trace (_loc1);
        _level0.CLIENT.PENGUIN.SHELL.world_crumbs[_loc1] = {name: "Alpine", ip: "127.0.0.1", port: "6113", id: _loc1, population: population};
    } // End of the function
    function bakeHandler(handler)
    {
        if (!_level0.CLIENT.HANDLERS[handler])
        {
            _level0.CLIENT.HANDLERS[handler] = {};
        } // end if
        return (function (rObj)
        {
            _level0.CLIENT.HANDLERVARS = [];
            for (var _loc2 in rObj)
            {
                _level0.CLIENT.HANDLERVARS[_loc2] = rObj[_loc2];
            } // end of for...in
            for (var _loc2 in _level0.CLIENT.HANDLERS[handler])
            {
                _level0.CLIENT.HANDLERS[handler][_loc2](_level0.CLIENT.HANDLERVARS);
            } // end of for...in
        });
    } // End of the function
    function handlePrivateMsg(obj)
    {
        obj.shift();
        var sender = obj.shift();
        var sendID = obj.shift();
        var msg = obj.shift();
        with (_level0.CLIENT.PENGUIN)
        {
            INTERFACE.openLog();
            addToChatLog({player_id: sendID, nickname: sender, message: msg, type: SEND_BLOCKED_MESSAGE});
        } // End of with
    } // End of the function
    function handleTimerKick(obj)
    {
        var timeout = obj.shift();
        var from = obj.shift();
        with (_level0.CLIENT.PENGUIN)
        {
            INTERFACE.showPrompt("ok", from + "Egg timer has been set.");
            SHELL.egg_timer_milliseconds_remaining = timeout * 60000;
            SHELL.setIsEggTimerActive(true);
        } // End of with
    } // End of the function
    function handleLoadMovie(obj)
    {
        trace ("Loading Movie...");
        obj.shift();
        loadMovieNum(obj.shift(), 5);
    } // End of the function
    function handleUpdateMood(obj)
    {
        var _loc1 = obj.shift();
        var _loc2 = obj.shift();
        _level0.CLIENT.PENGUIN.INTERFACE.getPlayerObject(_loc1).data[19] = _loc2;
        if (_level0.CLIENT.PENGUIN.INTERFACE.getActivePlayerId() == _loc1)
        {
        } // end if
    } // End of the function
    function handleSwfCommand(obj)
    {
        obj.shift();
        var func = obj.shift();
        var returnValue = this[func].apply(this, obj);
        with (_level0.CLIENT.PENGUIN.AIRTOWER)
        {
            send(PLAY_EXT, ICP_HANDLER + "#" + SWF_COMMAND, [returnValue], "str", -1);
        } // End of with
    } // End of the function
    function handleession(obj)
    {
        obj.shift();
        var _loc4 = obj.shift();
        var _loc5 = obj.shift();
        var _loc2 = obj.shift();
        var _loc3 = obj.shift();
        _level0.CLIENT.PENGUIN.SHELL.showErrorPrompt(_loc4, _loc5, _loc2, undefined, _loc3);
    } // End of the function
    function waitForInterface()
    {
        with (_level0.CLIENT.PENGUIN)
        {
            if (INTERFACE)
            {
                _level0.CLIENT._fireEvent("INTERFACE");
            } // end if
            if (ENGINE)
            {
                _level0.CLIENT._fireEvent("ENGINE");
            } // end if
            if (!INTERFACE || !ENGINE)
            {
                return;
            } // end if
            INTERFACE.DOCK.chat_mc.chat_input.maxChars = 4096;
            INTERFACE.convertToSafeCase = function (txt)
            {
                return (txt);
            };
            INTERFACE.isClickableLogItem = function ()
            {
                return (true);
            };
            INTERFACE.updatePlayerWidgetB = function (a, b, c, d, e, f, g)
            {
                if (!g)
                {
                    var _loc1 = INTERFACE.updatePlayerWidgetB(a, b, c, d, e, f, g);
                } // end if
                return (_loc1);
            };
            ENGINE.randomizeNearPosition = function (player, x, y, range)
            {
                player.x = x;
                player.y = y;
                return (true);
            };
        } // End of with
        for (var i in this.CLIENT.PLUGINS)
        {
            if (this.CLIENT.PLUGINS[i][1])
            {
                this.CLIENT.PLUGINS[i][0]();
            } // end if
        } // end of for...in
        delete this.onEnterFrame;
        delete _root.onEnterFrame;
        this.onEnterFrame = function ()
        {
            
        };
    } // End of the function
    function doModeratorAction(action)
    {
        switch (action)
        {
            case "openChatlog":
            case "joinRoom":
            case "goInvisible":
            case "getPlayerInfos":
            case "leaveMeAlone":
        } // End of switch
    } // End of the function
    function handleModRequest(obj)
    {
        obj.shift();
        var _loc7 = Number(obj.shift());
        var _loc5 = String(obj.shift());
        var _loc6 = String(obj.shift());
        var _loc3 = Number(obj.shift());
        var _loc8 = String(obj.shift());
        var _loc9 = Number(obj.shift());
        var _loc4 = "fv?";
        PLUGIN_HOLDER.Core.modReport_mc.reason.text = _loc5;
        PLUGIN_HOLDER.Core.modReport_mc.roomID.text = _loc7;
        PLUGIN_HOLDER.Core.modReport_mc.roomName.text = _loc4;
        PLUGIN_HOLDER.Core.modReport_mc.reporterPlayerName.text = _loc6;
        PLUGIN_HOLDER.Core.modReport_mc.reporterPlayerID.text = _loc3;
        PLUGIN_HOLDER.Core.modReport_mc.reportedPlayerName.text = _loc8;
        PLUGIN_HOLDER.Core.modReport_mc.reportedPlayerID.text = _loc9;
        _level2.debug_txt.text = "Received mod report.";
        _level0.modReport_mc._visible = false;
    } // End of the function
    function handlePluginLoad(obj)
    {
        obj.shift();
        with (_level0.CLIENT)
        {
            PLUGIN_HOLDER.createEmptyMovieClip(obj[0], PLUGIN_HOLDER.getNextHighestDepth());
            PLUGIN_HOLDER[obj[0]].loadMovie(obj[1]);
        } // End of with
        with (_level0.CLIENT.PENGUIN.AIRTOWER)
        {
            send(PLAY_EXT, ICP_HANDLER + "#" + PLUGIN_LOAD, ["I Can Haz airtower..."], "str", -1);
        } // End of with
    } // End of the function
    function handleServerData(obj)
    {
        obj.shift();
        with (_level0.CLIENT.PENGUIN)
        {
            SHELL.world_crumbs = new Array();
            var servers = new Array();
            for (var index in obj)
            {
                var rawServer = obj[index].split("|");
                SHELL.world_crumbs[rawServer[0]] = {id: rawServer[0], name: rawServer[1], ip: rawServer[2], port: rawServer[3]};
            } // end of for...in
        } // End of with
        with (_level0.CLIENT.PENGUIN.AIRTOWER)
        {
            send(PLAY_EXT, ICP_HANDLER + "#" + SERVER_DATA, ["Lalalala."], "str", -1);
        } // End of with
    } // End of the function
    function handleGetVersion(obj)
    {
        with (_level0.CLIENT.PENGUIN.AIRTOWER)
        {
            send(PLAY_EXT, ICP_HANDLER + "#" + GET_VERSION, [org.iCPTeam.iCPThree.iCPLoader.VNUMBER], "str", -1);
        } // End of with
    } // End of the function
    function _fireEvent(evtName)
    {
        for (var _loc2 in _level0.CLIENT.HANDLERS[evtName])
        {
            _level0.CLIENT.HANDLERS[evtName][_loc2]();
        } // end of for...in
        _level0.CLIENT.HANDLERS[evtName] = {};
    } // End of the function
    function _airtowerHandler(handler)
    {
        return (PENGUIN.AIRTOWER.addListener(handler, this.bakeHandler(handler)));
    } // End of the function
    function _setTextFormat(array, o)
    {
        var _loc5 = this._getProperty(array);
        var _loc3 = new TextFormat();
        for (var _loc4 in o)
        {
            _loc3[_loc4] = o[_loc4];
        } // end of for...in
        return (_loc5.setTextFormat(_loc3));
    } // End of the function
    function _getProperty(array)
    {
        var _loc3 = PENGUIN;
        for (var _loc2 = 0; _loc2 < array.length; ++_loc2)
        {
            _loc3 = _loc3[array[_loc2]];
        } // end of for
        return (_loc3);
    } // End of the function
    function _setProperty(array, data)
    {
        var _loc4 = PENGUIN;
        for (var _loc2 = 0; _loc2 < array.length; ++_loc2)
        {
            if (array.length == _loc2 + 1)
            {
                _loc4[array[_loc2]] = data;
            } // end if
            _loc4 = _loc4[array[_loc2]];
        } // end of for
    } // End of the function
    function _call(array, a, b, c, d, e, f, g, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z)
    {
        var _loc4 = PENGUIN;
        for (var i = 0; i < array.length; ++i)
        {
            if (array.length == i + 1)
            {
                return (_loc4[array[i]](a, b, c, d, e, f, g, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z));
            } // end if
            _loc4 = _loc4[array[i]];
        } // end of for
    } // End of the function
    function _makeCallback(shareVar)
    {
        var original = SHAREVARS[shareVar];
        SHAREVARS[shareVar] = function (a, b, c, d, e, f, g, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z)
        {
            return (original(a, b, c, d, e, f, g, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z));
        };
    } // End of the function
    function _callWithShareVars(array, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z)
    {
        a = SHAREVARS[a];
        b = SHAREVARS[b];
        c = SHAREVARS[c];
        d = SHAREVARS[d];
        e = SHAREVARS[e];
        f = SHAREVARS[f];
        g = SHAREVARS[g];
        h = SHAREVARS[h];
        i = SHAREVARS[i];
        j = SHAREVARS[j];
        k = SHAREVARS[k];
        l = SHAREVARS[l];
        m = SHAREVARS[m];
        n = SHAREVARS[n];
        o = SHAREVARS[o];
        p = SHAREVARS[p];
        q = SHAREVARS[q];
        r = SHAREVARS[r];
        s = SHAREVARS[s];
        t = SHAREVARS[t];
        u = SHAREVARS[u];
        v = SHAREVARS[v];
        w = SHAREVARS[w];
        x = SHAREVARS[x];
        y = SHAREVARS[y];
        z = SHAREVARS[z];
        return (this._call(array, a, b, c, d, e, f, g, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z));
    } // End of the function
    function _callBase(array, a, b, c, d, e, f, g, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z)
    {
        return (this._useBase(this._call(array, a, b, c, d, e, f, g, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z)));
    } // End of the function
    function _apply(array, base, args)
    {
        var _loc4 = PENGUIN;
        for (var _loc2 = 0; _loc2 < array.length; ++_loc2)
        {
            if (array.length == _loc2 + 1)
            {
                return (_loc4[array[_loc2]].apply(base, args));
            } // end if
            _loc4 = _loc4[array[_loc2]];
        } // end of for
    } // End of the function
    function _foreach(array)
    {
        var _loc2 = PENGUIN;
        var _loc4 = {};
        for (var _loc5 = 0; _loc5 < array.length; ++_loc5)
        {
            _loc2 = _loc2[array[_loc5]];
        } // end of for
        for (var _loc5 in _loc2)
        {
            _loc4[_loc5] = _loc2[_loc5];
        } // end of for...in
        return (_loc4);
    } // End of the function
    function _clone(array, level, a)
    {
        var _loc3 = PENGUIN;
        var _loc5 = {};
        for (var _loc2 = 0; _loc2 < array.length; ++_loc2)
        {
            _loc3 = _loc3[array[_loc2]];
        } // end of for
        _loc5 = this.secretForeach(_loc3, level, a);
        return (_loc5);
    } // End of the function
    function secretForeach(object, level, a)
    {
        var _loc3 = {};
        for (var _loc6 in object)
        {
            if ((typeof(object[_loc6]) == "object" || a) && level != 0)
            {
                _loc3[_loc6] = this.secretForeach(object[_loc6], level - 1);
                continue;
            } // end if
            _loc3[_loc6] = object[_loc6];
        } // end of for...in
        return (_loc3);
    } // End of the function
    function _delete(array)
    {
        var _loc4 = PENGUIN;
        for (var _loc2 = 0; _loc2 < array.length; ++_loc2)
        {
            if (array.length == _loc2 + 1)
            {
                delete _loc4[array[_loc2]];
            } // end if
            _loc4 = _loc4[array[_loc2]];
        } // end of for
    } // End of the function
    function _setTimeout(cmd, interval)
    {
        PENGUIN.setTimeout(cmd, interval);
    } // End of the function
    function _useBase(base)
    {
        return (PENGUIN = base);
    } // End of the function
    function _restoreBase()
    {
        return (PENGUIN = _global.PenguBackup);
    } // End of the function
    function _glow(mcP, a, b, c, d, e, f, g, h)
    {
        var _loc3 = this._getProperty(mcP);
        var _loc4 = new flash.filters.GlowFilter(a, b, c, d, e, f, g, h);
        var _loc2 = new Array();
        _loc2.push(_loc4);
        _loc3.filters = _loc2;
    } // End of the function
    function _initLoader()
    {
        _level0.CLIENT.loader = new MovieClipLoader();
        _level0.CLIENT.loader.addListener({onLoadInit: dumbHandler, onLoadError: dumbHandler, onLoadProgress: dumbHandler, onLoadStart: dumbHandler, onLoadComplete: dumbHandler});
        return (_level0.CLIENT.loader);
    } // End of the function
    function _addReplace(func)
    {
        var _loc2 = REPLACES.length;
        REPLACES[_loc2] = func;
        return (_loc2);
    } // End of the function
    function _removeReplace(id)
    {
        if (REPLACES[id])
        {
            delete REPLACES[id];
        }
        else
        {
            for (var _loc3 in REPLACES)
            {
                if (REPLACES[_loc3] == id)
                {
                    delete REPLACES[_loc3];
                } // end if
            } // end of for...in
        } // end else if
    } // End of the function
    function dumbHandler(mc)
    {
        _level0.CLIENT.PENGUIN.LAST_EVENT_MC = mc;
    } // End of the function
    var PLUGINS = new Array();
    var HOST = "127.0.0.1";
    var PENGUIN = "Not found yet";
    var REPLACES = new Array();
    var FAKE_LANG = {};
    var HANDLERS = {};
    var SHAREVARS = {};
    var HANDLERVARS = {};
	var AUTHOR = "Inject[Seether/G.N.]";
	var VERSION = "1.27alpha";
} // End of Class
