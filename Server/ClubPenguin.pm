package ClubPenguin;

use strict;
use warnings;

use Method::Signatures;
use Digest::MD5 qw(md5_hex);
use Math::Round qw(round);
use File::Basename;
use LWP::UserAgent;

method new($resConfig, $resDBConfig) {
       my $obj = bless {}, $self;
       $obj->{servConfig} = $resConfig;
       $obj->{dbConfig} = $resDBConfig;
       $obj->{handlers} =  {
               xml => {
                   verChk => 'handleVerChk',                          
                   rndK => 'handleRndK',				                    
                   login => 'handleLogin'
               },
               xt => {
                  s => {
                    'j#jp' => 'handleJoinPlayer',
                    'j#js' => 'handleJoinServer',
                    'j#jr' => 'handleJoinRoom',
                    'j#jg' => 'handleJoinGame',
                    'j#grs' => 'handleGetRoomSynced',
                    'b#gb' => 'handleGetBuddies',
                    'b#br' => 'handleBuddyRequest',
                    'b#ba' => 'handleBuddyAccept',
                    'b#rb' => 'handleRemoveBuddy',
                    'b#bf' => 'handleBuddyFind',
                    'f#epfai' => 'handleEPFAddItem',
                    'f#epfga' => 'handleEPFGetAgent',
                    'f#epfgr' => 'handleEPFGetRevision',
                    'f#epfgf' => 'handleEPFGetField',
                    'f#epfsf' => 'handleEPFSetField',
                    'f#epfsa' => 'handleEPFSetAgent',
                    'f#epfgm' => 'handleEPFGetMessage',
                    'g#af' => 'handleAddFurniture',
                    'g#ao' => 'handleUpdateIgloo',
                    'g#au' => 'handleAddIgloo',
                    'g#ag' => 'handleUpdateFloor',
                    'g#um' => 'handleUpdateMusic',
                    'g#gm' => 'handleGetIglooDetails',
                    'g#go' => 'handleGetOwnedIgloos',
                    'g#or' => 'handleOpenIgloo',
                    'g#cr' => 'handleCloseIgloo',
                    'g#gf' => 'handleGetOwnedFurniture',
                    'g#ur' => 'handleGetFurnitureRevision',
                    'g#gr' => 'handleGetOpenedIgloos',
                    'n#gn' => 'handleGetIgnored',
                    'n#an' => 'handleAddIgnore',
                    'n#rn' => ' handleRemoveIgnored',
                    'i#gi' => 'handleGetItems',
                    'i#ai' => 'handleAddItem',
                    'i#qpp' => 'handleQueryPlayerPins',
                    'i#qpa' => 'handleQueryPlayerAwards',
                    'm#sm' => 'handleSendMessage',
                    'r#cdu' => 'handleCoinsDigUpdate',
                    'o#k' => 'handleKick',
                    'o#m' => 'handleMute',
                    'o#b' => 'handleBan',
                    'p#ps' => 'handleSendPuffleFrame',
                    'p#pg' => 'handleGetPuffle',
                    'p#pip' => 'handlePufflePip',
                    'p#pir' => 'handlePufflePir',
                    'p#ir' => 'handlePuffleIsResting',
                    'p#ip' => 'handlePuffleIsPlaying',
                    'p#if' => 'handlePuffleIsFeeding',
                    'p#pw' => 'handlePuffleWalk',
                    'p#pgu' => 'handlePuffleUser',
                    'p#pf' => 'handlePuffleFeedFood',
                    'p#pn' => 'handleAdoptPuffle',
                    'p#pr' => 'handlePuffleRest',
                    'p#pp' => 'handlePufflePlay',
                    'p#pt' => 'handlePuffleFeed',
                    'p#pm' => 'handlePuffleMove',
                    'p#pb' => 'handlePuffleBath',
                    'u#sf' => 'handleSetFrame',
                    'u#se' => 'handleSendEmote',
                    'u#sa' => 'handleSendAction',
                    'u#ss' => 'handleSendSafe',
                    'u#sg' => 'handleSendGuide',
                    'u#sj' => 'handleSendJoke',
                    'u#sma' => 'handleSendMascot',
                    'u#sp' => 'handleSetPosition',
                    'u#sb' => 'handleSnowball',
                    'u#glr' => 'handleGetLatestRevision',
                    'u#gp' => 'handleGetPlayer',
                    'u#h' => 'handleHeartbeat',
                    'l#mst' => 'handleMailStart',
                    'l#mg' =>	'handleMailGet',
                    'l#ms' =>	'handleMailSend',
                    'l#md'	=>	'handleMailDelete',
                    'l#mdp'	=>	'handleMailDeletePlayer',
                    'l#mc' =>	'handleMailChecked',
                    's#upc' => 'handleUpdatePlayerClothing',
                    's#uph' => 'handleUpdatePlayerClothing',
                    's#upf' => 'handleUpdatePlayerClothing',
                    's#upn' => 'handleUpdatePlayerClothing',
                    's#upb' => 'handleUpdatePlayerClothing',
                    's#upa' => 'handleUpdatePlayerClothing',
                    's#upe' => 'handleUpdatePlayerClothing',
                    's#upp' => 'handleUpdatePlayerClothing',
                    's#upl' => 'handleUpdatePlayerClothing',			
                    'st#sse'	=> 'handleSendStampEarned',
                    'st#gps'	=>	'handleGetPlayersStamps',
                    'st#gmres' =>	'handleGetMyRecentlyEarnedStamps',
                    'st#gsbcd' =>	'handleGetStampBookCoverDetails',
                    'st#ssbcd'	=>	'handleSetStampBookCoverDetails',
                    't#at' => 'handleAddToy',
                    't#rt' => 'handleRemoveToy',
                    'ni#gnr' => 'handleGetNinjaRanks',
                    'ni#gnl' => 'handleGetNinjaLevel',
                    'ni#gcd' => 'handleGetCards',
                    'ni#gfl' => 'handleGetFireLevel',
                    'ni#gwl' => 'handleGetWaterLevel',
                    'ni#gsl' => 'handleGetSnowLevel',
                    'a#jt' => 'handleJoinTable',
                    'a#gt' => 'handleGetTable',
                    'a#ut' => 'handleUpdateTable',
                    'a#lt' => 'handleLeaveTable',
                    'w#jx' => 'handleSendWaddle',
                    'iCP#umo' => 'handleUpdateMood',
	     	    'e#sig' => 'handleSignIglooContest',
		    'e#dc' => 'handleDonateCoins'
                  },
                  z => {
                     zo => 'handleGameOver',
                     m => 'handleMovePuck',
                     gz => 'handleGetZone',
                     jz => 'handleJoinZone',
                     zm => 'handleSendMove'
                  }
              }
       };
       $obj->{iplog} = {};
       $obj->{igloos} = {};
       $obj->{systems} = {};
       $obj->{plugins} = {};
       $obj->{clients} = {};
       return $obj;
}

method initializeSource {
       $self->createHeader;
       $self->loadModules;
       $self->initiateMysql;
       if ($self->{servConfig}->{servType} ne 'login') {
	   if ($self->{servConfig}->{autoUpdateCrumbs}) {
		   if ($self->isInternetConnected) {
			   $self->{modules}->{crumbs}->updateCrumbs;
		   } else {
			   $self->{modules}->{logger}->output('Failed To Update Crumbs Due To No Internet Access', Logger::LEVELS->{err}); 
			   $self->{modules}->{logger}->output('Default Crumbs Are Going To Be Used Instead', Logger::LEVELS->{ntc}); 
		   }
	   } else {
		   $self->{modules}->{logger}->output('Crumbs Auto Updating Is Disabled...Resorting To Default Crumbs', Logger::LEVELS->{ntc}); 
	   }
           $self->{modules}->{crumbs}->loadCrumbs;
           $self->loadSystems;
           if ($self->{servConfig}->{servType} eq 'game') {
               $self->createServer;
           }
       }
       $self->loadPlugins;
       $self->initiateServer;
}

method isInternetConnected {
	   my $resPing = LWP::UserAgent->new;
	   my $resRequest = HTTP::Request->new(GET => 'http://clubpenguin.com');
	   my $blnResp = $resPing->request($resRequest);
       return $blnResp->is_success ? 1 : 0;
}

method createHeader {
       print chr(10);
       print '*************************************' . chr(10);
       print '*              Luna                 *' . chr(10);
       print '*************************************' . chr(10);
       print '*   Club Penguin Server Emulator    *' . chr(10);
       print '*************************************' . chr(10);
       print '*   Creator: Lynx                   *' . chr(10);
       print '*   Author: Lake                    *' . chr(10);
       print '*   License: MIT                    *' . chr(10);
       print '*   Protocol: Actionscript 2.0      *' . chr(10);
       print '*************************************' . chr(10);
       print chr(10);
}

method loadModules {
       $self->{modules} = {
               logger => Logger->new,
               mysql => MySQL->new,
               base => Socket->new($self),
               crypt => Cryptography->new,
               tools => Tools->new,
               crumbs => Crumbs->new($self),
               pbase => CPPlugins->new($self),
               commands => CPCommands->new($self),
               matches => Matches->new($self)
       };
}

method loadSystems {       
       my @arrFiles = glob('Server/Systems/*.pm');
       foreach (@arrFiles) {
                my $strClass = basename($_, '.pm');
                my $objSystem = $strClass->new($self);
                $self->{systems}->{$strClass} = $objSystem;
       }
       my $sysCount = scalar(keys %{$self->{systems}});
       if ($sysCount > 0) {
           $self->{modules}->{logger}->output('Successfully Loaded ' . $sysCount . ' Systems', Logger::LEVELS->{inf}); 
       } else {
           $self->{modules}->{logger}->output('Failed To Load Any Systems', Logger::LEVELS->{err}); 
       }
}


method loadPlugins {       
       my @arrFiles = glob('Server/Plugins/*.pm');
       foreach (@arrFiles) {
                my $strClass = basename($_, '.pm');
                my $objPlugin = $strClass->new($self);
                $self->{plugins}->{$strClass} = $objPlugin;
       }
       my $pluginCount = scalar(keys %{$self->{plugins}});
       if ($pluginCount > 0) {
           $self->{modules}->{logger}->output('Successfully Loaded ' . $pluginCount . ' Plugins', Logger::LEVELS->{inf}); 
       } else {
           $self->{modules}->{logger}->output('Failed To Load Any Plugins', Logger::LEVELS->{err}); 
       }
}

method initiateMysql {
       $self->{modules}->{mysql}->createMysql($self->{dbConfig}->{dbHost}, $self->{dbConfig}->{dbName}, $self->{dbConfig}->{dbUser}, $self->{dbConfig}->{dbPass}) or $self->{modules}->{logger}->kill('Failed To Connect To Mysql', Logger::LEVELS->{err});
       $self->{modules}->{logger}->output('Successfully Connected To Mysql', Logger::LEVELS->{inf}); 
}

method createServer {
       my $blnExist = $self->{modules}->{mysql}->serverExists($self->{servConfig}->{servPort});
       if ($blnExist <= 0) {
           $self->{modules}->{mysql}->insertData('servers', ['servPort', 'servName', 'servIP'], [$self->{servConfig}->{servPort}, $self->{servConfig}->{servName}, $self->{servConfig}->{servHost}]);       
       }
}

method initiateServer {
       $self->{modules}->{base}->createSocket($self->{servConfig}->{servPort}) or $self->{modules}->{logger}->kill('Failed to Bind to Port: ' . $self->{servConfig}->{servPort}, Logger::LEVELS->{err});
       $self->{modules}->{logger}->output('Successfully Started ' . ucfirst($self->{servConfig}->{servType}) . ' Server', Logger::LEVELS->{inf});
}

method handleCustomPlugins($strType, $strData, $objClient) {    
       my $blnXML = $strType eq 'xml' ? 1 : 0;
       my $blnXT = $strType eq 'xt' ? 1 : 0;
       return if (!$blnXML && !$blnXT);
       $blnXML ? $self->{modules}->{pbase}->handleXMLData($strData, $objClient) : $self->{modules}->{pbase}->handleXTData($strData, $objClient);
}

method handleXMLData($strData, $objClient) {
       if ($strData eq '<policy-file-request/>') {
	          return $self->handleCrossDomainPolicy($objClient);
       }
       my $strXML = $self->{modules}->{tools}->parseXML($strData);
       if (!$strXML) {
           return $self->{modules}->{base}->removeClient($objClient->{sock});
       }
       my $strAct = $strXML->{body}->{action};
       return if (!exists($self->{handlers}->{xml}->{$strAct}));
       my $strHandler = $self->{handlers}->{xml}->{$strAct};
       return if (!defined(&{$strHandler}));
       $self->$strHandler($strXML, $objClient);
       $self->handleCustomPlugins('xml', $strData, $objClient);
}

method handleCrossDomainPolicy($objClient) {
       $objClient->write("<cross-domain-policy><allow-access-from domain='*' to-ports='" . $self->{servConfig}->{servPort} . "'/></cross-domain-policy>");
}

method handleVerChk($strXML, $objClient) {
       return $strXML->{body}->{ver}->{v} == 153 ? $objClient->write("<msg t='sys'><body action='apiOK' r='0'></body></msg>") : $objClient->write("<msg t='sys'><body action='apiKO' r='0'></body></msg>");
}

method handleRndK($strXML, $objClient) {
       $objClient->{loginKey} = $self->{modules}->{crypt}->generateKey;
       $objClient->write("<msg t='sys'><body action='rndK' r='-1'><k>" . $objClient->{loginKey} . "</k></body></msg>");
}

method handleLogin($strXML, $objClient) {     
       my $strName = $strXML->{body}->{login}->{nick};
       my $strPass = $strXML->{body}->{login}->{pword};     
       $self->checkBeforeLogin($strName, $strPass, $objClient);
}

method checkBeforeLogin($strName, $strPass, $objClient) {
       if ($strName !~ /^[[:alnum:]]+$/) {
       	   $objClient->sendError(100);
       	   return $self->{modules}->{base}->removeClient($objClient->{sock});
       }
       my $intNames = $self->{modules}->{mysql}->usernameExists($strName);
       if ($intNames <= 0) {
           $objClient->sendError(100);
           return $self->{modules}->{base}->removeClient($objClient->{sock});
       }
       my $arrInfo = $self->{modules}->{mysql}->getDetailsByUsername($strName);
       my $strHash = $self->generateHash($arrInfo, $objClient);             
       if ($strPass ne $strHash) {
           $objClient->sendError(101);	
           $objClient->updateInvalidLogins($arrInfo->{invalidLogins} + 1, $strName);
           return $self->{modules}->{base}->removeClient($objClient->{sock});
       } elsif ($arrInfo->{invalidLogins} > 5) {
           $objClient->sendError(150);
           return $self->{modules}->{base}->removeClient($objClient->{sock});
       } elsif (!$arrInfo->{active})  {
           $objClient->sendError(900);
           return $self->{modules}->{base}->removeClient($objClient->{sock});
       } elsif ($arrInfo->{isBanned} eq 'PERM') {
                  $objClient->sendError(603);	
                  return $self->{modules}->{base}->removeClient($objClient->{sock});                
       } elsif (int($arrInfo->{isBanned})) {
                 if ($arrInfo->{isBanned} > time) {
                     my $intTime = round(($arrInfo->{isBanned} - time) / 3600);
                     $objClient->sendError(601 . '%' . $intTime);	
                     return $self->{modules}->{base}->removeClient($objClient->{sock});  
                 }              
       }
       $self->continueLogin($strName, $arrInfo, $objClient);
} 

method generateHash($arrInfo, $objClient) {
       my $strLoginKey = $objClient->{loginKey};
       my $strLoginHash = $self->{modules}->{crypt}->digestHash(uc($arrInfo->{password}), $strLoginKey);                            
       my $strGameHash = $self->{modules}->{crypt}->swapHash(md5_hex($arrInfo->{loginKey} . $strLoginKey)) . $arrInfo->{loginKey};
       my $strType = $self->{servConfig}->{servType};
       my $strHash = $strType eq 'login' ? $strLoginHash : $strGameHash;
       return $strHash;
}

method continueLogin($strName, $arrInfo, $objClient) {
       if ($self->{servConfig}->{servType} eq 'login') {
           $objClient->write('%xt%gs%-1%' . $self->generateServerList . '%');  
           $objClient->write('%xt%l%-1%' . $arrInfo->{ID} . '%' . $self->{modules}->{crypt}->reverseHash($objClient->{loginKey}) . '%0%');
           $objClient->updateKey($self->{modules}->{crypt}->reverseHash($objClient->{loginKey}), $strName);
       } else {
           $objClient->{ID} = $arrInfo->{ID};
           $objClient->{isAuth} = 1;
           $objClient->updateIP($objClient->{ipAddr});
           $objClient->loadDetails;
           $objClient->sendXT(['l', '-1']);
           $objClient->handleBuddyOnline;
       }
       $objClient->updateInvalidLogins(0, $strName);
}

method generateServerList {
       my $strServer = '';
       my $arrInfo = $self->{modules}->{mysql}->getServerDetailsByType('game');
       foreach (values @{$arrInfo}) {
                my $intPopulation = $_->{curPop};
                my $intBars = 0;
                if ($intPopulation <= 50) {    
                    $intBars = 1;
                } elsif ($intPopulation > 50 && $intPopulation <= 100) {
                    $intBars = 2;
                } elsif ($intPopulation > 100 && $intPopulation <= 200) {
                    $intBars = 3;
                } elsif ($intPopulation > 200 && $intPopulation <= 300) {
                    $intBars = 4;
                } elsif ($intPopulation > 300 && $intPopulation <= 400) {
                    $intBars = 5;
                } elsif ($intPopulation > 400 && $intPopulation <= 500 && $intPopulation > 500) {
                    $intBars = 6;
                }
                $strServer .= $_->{servIP} . ':' . $_->{servPort} . ':' . $_->{servName} . ':' . $intBars . '|';
       }
       return $strServer;
}

method handleXTData($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $chrXT = $arrData[2];
       my $stdXT = $arrData[3];
       return if (!exists($self->{handlers}->{xt}->{$chrXT}->{$stdXT}));
       if (index($strData, '|') != -1 && $stdXT ne 'g#ur' && $stdXT ne 'm#sm' && $stdXT ne 'st#ssbcd') {
           return $self->{modules}->{base}->removeClient($objClient->{sock});
       }
       my $strHandler = $self->{handlers}->{xt}->{$chrXT}->{$stdXT};
       if (!$objClient->{isAuth} || $objClient->{username} eq "" || !defined($objClient->{username})) {
           return $self->{modules}->{base}->removeClient($objClient->{sock});
       } else {
           foreach (values %{$self->{systems}}) {
                    if ($_->can($strHandler)) {
                        $_->$strHandler($strData, $objClient);
                    }
           }
           $self->handleCustomPlugins('xt', $strData, $objClient);
       }
}

1;
