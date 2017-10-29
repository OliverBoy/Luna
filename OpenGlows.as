var INTERFACE = _global.getCurrentInterface();
var ENGINE = _global.getCurrentEngine();
var SHELL = _global.getCurrentShell();
var AIRTOWER = _global.getCurrentAirtower();
var Players = {};
import flash.filters.GlowFilter;

ENGINE.onPlayerLoadStart = function(event){
    SetGlows();
    event.target._visible = false;
}

INTERFACE.updatePlayerWidgetO = INTERFACE.updatePlayerWidget;
INTERFACE.updatePlayerWidget = function() {
   INTERFACE.updatePlayerWidgetO();
   var mP = INTERFACE.getActivePlayerId() == SHELL.getMyPlayerId();
   var player_ob = INTERFACE.getPlayerObject(INTERFACE.getActivePlayerId());
   var glow = new flash.filters.DropShadowFilter(0, 0, Players[player_ob.player_id].MoodGlow, 20, 5, 5, 15, 3);
   var tF = new TextFormat();
   tF.font = "Burbank Small Medium";
   tF.size = 12;
   tF.align = "center";
   tF.color = Players[player_ob.player_id].MoodColor;

   INTERFACE.PLAYER_WIDGET.art_mc.createTextField("pMood_txt",2, 10, 230, 203, 16);
   INTERFACE.PLAYER_WIDGET.art_mc.pMood_txt.text = Players[player_ob.player_id].Mood;
   INTERFACE.PLAYER_WIDGET.art_mc.pMood_txt.selectable = mP;
   INTERFACE.PLAYER_WIDGET.art_mc.pMood_txt.setTextFormat(tF);
   INTERFACE.PLAYER_WIDGET.art_mc.pMood_txt.filters = [glow];
   if(mP) {
      INTERFACE.PLAYER_WIDGET.art_mc.pMood_txt.type = "input";
      INTERFACE.PLAYER_WIDGET.art_mc.pMood_txt.onKillFocus = function() {
         if(this.text == " " || this.text == "") {
            this.text = "DEFAULT MOOD CAN CHANGE";
         }
         var newMood = this.text;
         Players[player_ob.player_id].Mood = newMood;
         with(_level0.CLIENT.PENGUIN.AIRTOWER) {
            send(PLAY_EXT,"iCP#umo",[newMood],"str",-1)

         };
      };
   }
};

function SetGlows(){
    for(var PlayerIndex in Players) {
        if(Players[PlayerIndex].Namecolor) {
            var PlayerName = INTERFACE.nicknames_mc["p" + PlayerIndex].name_txt;
            PlayerName.textColor = Players[PlayerIndex].Namecolor;
        }
        if(Players[PlayerIndex].Nameglow) {
            var PlayerName = INTERFACE.nicknames_mc["p" + PlayerIndex];
            var Glow = new flash.filters.DropShadowFilter(0, 0, Players[PlayerIndex].Nameglow, 20, 5, 5, 15, 3);
            PlayerName.name_txt.filters = [Glow];
        }
        if (Players[PlayerIndex].ChatGlow){
            var Glow = new flash.filters.DropShadowFilter(0, 0, Players[PlayerIndex].ChatGlow, 20, 5, 5, 15, 3);
            INTERFACE.interface_mc.dock_mc.chat_mc.chat_input.filters = [Glow];
        }
        if (Players[PlayerIndex].PenguinGlow) {
	    	Penguin = ENGINE.room_mc.load_mc["p" + PlayerIndex];
		    var Glow = new flash.filters.DropShadowFilter(0, 0, Players[PlayerIndex].PenguinGlow, 20, 5, 5, 15, 3);
            Penguin.filters = [Glow];
        }
        if(Players[PlayerIndex].BubbleColor) {
            var i = INTERFACE.BALLOONS["p" + PlayerIndex];
            var _loc1 = new Color(i.balloon_mc);
            _loc1.setRGB(Players[PlayerIndex].BubbleColor);
            var _loc2 = new Color(i.pointer_mc);
            _loc2.setRGB(Players[PlayerIndex].BubbleColor);
        }
        if(Players[PlayerIndex].BubbleGlow) {
            var pballon = INTERFACE.BALLOONS["p" + PlayerIndex];
            var Glow = new flash.filters.DropShadowFilter(0, 0, Players[PlayerIndex].BubbleGlow, 20, 5, 5, 15, 3);
            pballon.balloon_mc.filters = [Glow];
            pballon.pointer_mc.filters = [Glow];
        }
        if(Players[PlayerIndex].BubbleTextColor) {
            var mc = INTERFACE.BALLOONS["p" + PlayerIndex];
            mc.message_txt.textColor = Players[PlayerIndex].BubbleTextColor;
        }
        if (Players[PlayerIndex].RingColor) {
            ENGINE.room_mc.load_mc["p" + PlayerIndex].art_mc.ring._visible = true;
            var _loc3 = new Color(ENGINE.room_mc.load_mc["p" + PlayerIndex].art_mc.ring);
            _loc3.setRGB(Players[PlayerIndex].RingColor);
        }
        if(Players[PlayerIndex].Transformation) {
            ENGINE.room_mc.load_mc["p" + PlayerIndex].art_mc.loadMovie("http://localhost/play/v2/content/global/penguin/other/" + Players[PlayerIndex].Transformation + ".swf");
        }
        if(Players[PlayerIndex].Title) {
			var PlayerName = INTERFACE.nicknames_mc["p" + PlayerIndex];	
			var tglow = new flash.filters.DropShadowFilter(0, 0, Players[PlayerIndex].TitleGlow, 20, 5, 5, 15, 3);
			var title_txt = new TextFormat();
			title_txt.size = 8;
			title_txt.color = Players[PlayerIndex].TitleColor;
			title_txt.align = 'center';
			title_txt.font = 'Burbank Small Medium';
			PlayerName.createTextField('title_mc', 4, -50, 25, 100, 13);
			PlayerName.title_mc.selectable = false;
			PlayerName.title_mc.text =  Players[PlayerIndex].Title;
			PlayerName.title_mc.filters = [tglow];
			PlayerName.title_mc.setTextFormat(title_txt);
		}
	}
}

function UpdatePlayer(PlayerArray){
    Players[PlayerArray[0]] = {
        Nameglow: PlayerArray[17], 
        Namecolor: PlayerArray[18],
        BubbleColor: PlayerArray[19],
        BubbleTextColor: PlayerArray[20],
        RingColor: PlayerArray[21],
        Speed: PlayerArray[22],
        Title: PlayerArray[23],
        Mood: PlayerArray[24],
        ChatGlow: PlayerArray[25],
        PenguinGlow: PlayerArray[26],
        BubbleGlow: PlayerArray[27],
        MoodGlow: PlayerArray[28],
        MoodColor: PlayerArray[29],
        SnowballGlow: PlayerArray[30],
        Walls: PlayerArray[31],
        Transformation: PlayerArray[32],
        TitleGlow: PlayerArray[33],
        TitleColor: PlayerArray[34]
    };
}

INTERFACE.showBalloon2 = INTERFACE.showBalloon;
INTERFACE.showBalloon = function(player_id, msg) {
    var _loc4_ = INTERFACE.showBalloon2(player_id,msg);
    var _loc1_ = INTERFACE.getPlayerObject(player_id);
    SetGlows();
    return _loc4_;
}

ENGINE.randomizeNearPosition = function(player, x, y, range) {
            player.x = x;
            player.y = y;
            return true;
}

ENGINE.movePlayer = function(player_id, target_x, target_y, is_trigger, frame){
    var _local4 = ENGINE.getRoomMovieClip();
    if (is_trigger == undefined) {
        is_trigger = true;
    }
    var mc = ENGINE.getPlayerMovieClip(player_id);
    var start_x = Math.round(mc._x);
    var start_y = Math.round(mc._y);
    if (mc.is_reading) {
        ENGINE.removePlayerBook(player_id);
    }
    if (!mc.is_ready) {
        ENGINE.updatePlayerPosition(player_id, target_x, target_y);
    } else {
        var _local3 = ENGINE.findDistance(start_x, start_y, target_x, target_y);
        if (_local4.ease_method == "easeInOutQuad") {
            var easeFunction = ENGINE.mathEaseInOutQuad;
        } else {
            var easeFunction = ENGINE.mathLinearTween;
        }
        var _local2 = ENGINE.findAngle(start_x, start_y, target_x, target_y);
        var d = ENGINE.findDirection(_local2);
        var duration = (_local3 / 4);
        if(Players[player_id].Speed) {
            var duration = (_local3 / Players[player_id].Speed);
        }
        var change_x = (target_x - start_x);
        var change_y = (target_y - start_y);
        mc.is_moving = true;
        ENGINE.updatePlayerFrame(player_id, d + 8);
        var t = 0;
        mc.onEnterFrame = function () {
            t++;
            if (t < duration) {
            x = easeFunction(t, start_x, change_x, duration);
            y = easeFunction(t, start_y, change_y, duration);
            ENGINE.updatePlayerPosition(player_id, x, y);
            } else {
                mc.is_moving = false;
                ENGINE.updatePlayerPosition(player_id, target_x, target_y);
                ENGINE.updatePlayerFrame(player_id, d);
                ENGINE.SHELL.sendPlayerMoveDone(player_id);
                this.onEnterFrame = null;
                delete this.onEnterFrame;
                if (ENGINE.SHELL.isMyPlayer(player_id)) {
                    ENGINE.playerMoved.dispatch();
                    ENGINE.setPlayerAction("wait");
                    if (is_trigger && (ENGINE.isMouseActive())) {
                        ENGINE.checkTrigger(mc);
                        ENGINE.checkFieldOpTriggered(mc);
                    }
                    if (frame != undefined) {
                        ENGINE.sendPlayerFrame(frame);
                    }
                }
            }
        };
    }
};

ENGINE.throwBall = function (player_id, target_x, target_y, start_height, max_height, wait) {
	var _local2 = ENGINE.getPlayerMovieClip(player_id);
	var room_mc = ENGINE.getRoomMovieClip();
	if (_local2.is_reading) {
		ENGINE.removePlayerBook(player_id);
	}
	if (_local2.is_ready && (!_local2.is_moving)) {
		if (throw_item_counter == undefined) {
			throw_item_counter = 0;
		}
		if (throw_item_counter > 10) {
			throw_item_counter = 0;
		}
		var start_x = _local2._x;
		var start_y = _local2._y;
		var c = (throw_item_counter++);
		var _local3 = "i" + c;
		if (room_mc[_local3] != undefined) {
			room_mc[_local3].removeMovieClip();
		}
		 room_mc.attachMovie("ball", _local3, 1000200 + c);
		 var mc = room_mc[_local3];
		 mc.player_id = player_id;
		 mc.id = c;
		 mc._x = start_x;
		 mc._y = start_y;
		 ENGINE.updateItemDepth(mc, c);
		 var _local6 = ENGINE.findDistance(start_x, start_y, target_x, target_y);
		 var _local5 = ENGINE.findAngle(start_x, start_y, target_x, target_y);
		 var _local4 = Math.round(ENGINE.findDirection(_local5) / 2);
		 ENGINE.updatePlayerFrame(player_id, 26 + _local4);
		 var duration = (_local6 / 15);
		 var change_x = (target_x - start_x);
		 var change_y = (target_y - start_y);
		 var peak = (duration / 2);
		 var change_height1 = (max_height - start_height);
		 var change_height2 = (-max_height);
		 mc.art._y = start_height;
		 mc._visible = false;
		 var t = 0;
		 var w = 0;
		 mc.onEnterFrame = function () {
		 if (w > wait) {
			 mc._visible = true;
			 if(Players[player_id].SnowballGlow) {
				var sglow = new flash.filters.DropShadowFilter(0, 0, Players[player_id].SnowballGlow, 20, 5, 5, 15, 3)
				mc.filters = [sglow];
			 }
			 t++;
			 if (t < duration) {
				 mc._x = ENGINE.mathLinearTween(t, start_x, change_x, duration);
				 mc._y = ENGINE.mathLinearTween(t, start_y, change_y, duration);
				 ENGINE.updateItemDepth(mc, c);
				 if (t < peak) {
					 mc.art._y = ENGINE.mathEaseOutQuad(t, start_height, change_height1, peak);
				 } else {
					 mc.art._y = ENGINE.mathEaseInQuad(t - peak, max_height, change_height2, peak);
				 }
			 } else {
				 mc._x = target_x;
				 mc._y = target_y;
				 mc.art._y = 0;
				 mc.gotoAndStop(2);
				 room_mc.handleThrow(mc);
				 _level0.CLIENT.PENGUIN.SHELL.updateListeners(_level0.CLIENT.PENGUIN.SHELL.BALL_LAND, {id:mc.id, player_id:mc.player_id, x:mc._x, y:mc._y});
				 if (room_mc.snowballBlock != undefined) {
					 if (room_mc.snowballBlock.hittest(mc._x, mc._y, true)) {
						 mc._visible = false;
					 }
				 }
				 this.onEnterFrame = null;
			 }
		 } else {
			 w++;
		 }
	 }
	}
};

ENGINE.findPlayerPath = function(player_id, x, y) { 
	var _local12 = ENGINE.getPlayerMovieClip(player_id); 
	var _local7 = ENGINE.getRoomBlockMovieClip(); 
	var _local13 = ENGINE.getValidXPosition(x); 
	var _local14 = ENGINE.getValidYPosition(y); 
	var _local11 = Math.round(_local12._x); 
	var _local10 = Math.round(_local12._y); 
	var _local15 = ENGINE.findDistance(_local11, _local10, _local13, _local14); 
	var _local6 = Math.round(_local15); 
	var _local9 = (_local13 - _local11) / _local6; 
	var _local8 = (_local14 - _local10) / _local6; 
	var _local4 = _local11; var _local3 = _local10; 
	var _local5 = new Object();
	_local5.x = _local11;
	_local5.y = _local10;
	var _local16 = _local7.hitTest(_local11, _local10, true);
	while (_local6 > 0) { 
		_local4 = _local4 + _local9;
		_local3 = _local3 + _local8;
		var _local2 = Math.round(_local4);
		var _local1 = Math.round(_local3);
		if(Players[player_id].Walls != 1){
			if (_local7.hitTest(_local2, _local1, true)) {
				break; 
			} 
		}
		_local5.x = _local2;
		_local5.y = _local1; 
		_local6--; 
	} 
	return(_local5); 
}

SHELL.getPlayerHexFromId = function (id) {
	if ((id < 50) || (!isNaN(_loc2.colour_id))) {
		var _local1 = SHELL.getPlayerColoursObject();
		if (_local1[id] != undefined) {
			return(_local1[id]);
		}
		return(_local1[0]);
	}
	return(id);
};

SHELL.getMyPlayerHex = function() {
	var _loc2 = SHELL.getMyPlayerObject();
	var _loc1 = SHELL.getPlayerColoursObject();
	if((_loc2.colour_id) < 50 || isNaN(_loc2.colour_id))
		return _loc2.colour_id;
	if (_loc1[_loc2.colour_id] != undefined){
		return (_loc1[_loc2.colour_id]);
	} else {
		return (_loc1[0]);
	} 
};

SHELL.handleSendUpdatePlayerColour = function(obj) {
	var _loc5 = obj.shift();
	var _loc1 = Number(obj[0]);
	var _loc3 = Number(obj[1]);
	
	if (SHELL.isMyPlayer(_loc1)){
		SHELL.setMyPlayerHexById(_loc3);
	} 
	var _loc2 = SHELL.getPlayerObjectFromRoomById(_loc1);
	if (_loc2 != undefined){
		_loc2.colour_id = _loc3;
		_loc2.frame_hack = SHELL.buildFrameHacksString(_loc2);
		SHELL.updateListeners(SHELL.UPDATE_PLAYER, _loc2);
		if (SHELL.isMyPlayer(_loc1))
		{
			SHELL.com.clubpenguin.login.LocalData.saveRoomPlayerObject(_loc2);
		} 
	} else {
		SHELL.$e("[shell] handleSendUpdatePlayerColour() -> Could not find player in room! player_id:" + _loc1);
	} 
};

SHELL.setMyPlayerHexById = function(id) {
	var _loc1 = SHELL.getMyPlayerObject();
	var _loc3 = _loc1.colour_id;
	_loc1.colour_id = id;
	if (SHELL.player_colours[_loc1.colour_id] != undefined){
		return (SHELL.player_colours[_loc1.colour_id]);
	} else {
		return id;
	}
};


function OpenGlows() {  
    _global.handleJoinRoom = function(obj) {
        for(var Index in obj){
            PlayerArray = obj[Index].split("|");
            UpdatePlayer(PlayerArray);     
        }   
    }
    AIRTOWER.addListener("jr", _global.handleJoinRoom);  
     
    _global.handleAddPlayer = function(obj) {     
        Player = obj.shift();     
        PlayerArray = Player.split("|");     
        UpdatePlayer(PlayerArray);     
        SetGlows();   
    }   
    AIRTOWER.addListener("ap", _global.handleAddPlayer);   
    
    _global.handleUpdatePlayer = function(obj) {     
        v = obj.shift();     
        Player = obj.shift();     
        PlayerArray = Player.split("|");     
        UpdatePlayer(PlayerArray);     
        SetGlows();   
    }   
    AIRTOWER.addListener("up", _global.handleUpdatePlayer); 
    
    _global.showEmoteBalloon = function(obj) {
        obj.shift();
        id = obj[0];
        color = Players[id].BubbleColor;
        glow = Players[id].BubbleGlow;
        if(color) {
            var _loc3_ = new Color(INTERFACE.balloons_mc["p" + id].balloon_mc);
            var _loc4_ = new Color(INTERFACE.balloons_mc["p" + id].pointer_mc);
            _loc3_.setRGB(color);
            _loc4_.setRGB(color);
        }
        if (glow) {
			var bglow = new flash.filters.DropShadowFilter(0, 0, glow, 20, 5, 5, 15, 3);
			var _loc5 = INTERFACE.balloons_mc["p" + id].balloon_mc;
            var _loc6 = INTERFACE.balloons_mc["p" + id].pointer_mc;
            _loc5.filters = [bglow];
            _loc6.filters = [bglow];
		}
    }
    AIRTOWER.addListener("se", _global.showEmoteBalloon);
}
OpenGlows();
