package Bot;

use strict;
use warnings;

use Method::Signatures;
use Data::RandomPerson;
use LWP::Simple;
use JSON qw(decode_json);
use URI::Escape;
use WebService::UrbanDictionary;

method new($resChild) {
       my $obj = bless {}, $self;
       $obj->{child} = $resChild;
       $obj->{pluginType} = 2;
       $obj->{property} = {
              'j#jr' => { 
                     handler => 'handleLoadBot',
                     isEnabled => 1
              },
              'j#js' => { 
                     handler => 'handleLoadBot',
                     isEnabled => 1
              },
              'm#sm' => {
				     handler => 'handleBotCommands',
                     isEnabled => 1
			  }
       };
	   $obj->{commands} = {
		      move => 'handleMoveBot',
		      dance => 'handleDance',
		      sit => 'handleSitDown',
		      '8ball' => 'handle8BallQuestions',
		      joke => 'handleSayRandomJoke',
		      slack => 'handleSlackPenguin',
		      yomomma => 'handleYoMommaJokes',
		      fortcookie => 'handleFortuneCookie',
		      advice => 'handleGiveAdvice',
		      udict => 'handleUrbanDictionary'
	   };
       return $obj;
}

method generateRandomColor {
		my @set = ('0' ..'9', 'A' .. 'F');
		my $str = join '' => map $set[rand @set], 0 .. 6;
		return $str;
}

method generateRandomHead {
	   my @arrHeads = ();
	   foreach (keys %{$self->{child}->{modules}->{crumbs}->{itemCrumbs}}) {
				if ($self->{child}->{modules}->{crumbs}->{itemCrumbs}->{$_}->{type} == 2) {
					push(@arrHeads, $_);
				}
	   }
	   my $intRandHead = $arrHeads[rand(@arrHeads)];
	   return $intRandHead;
}

method generateRandomFace {
	   my @arrFaces = ();
	   foreach (keys %{$self->{child}->{modules}->{crumbs}->{itemCrumbs}}) {
				if ($self->{child}->{modules}->{crumbs}->{itemCrumbs}->{$_}->{type} == 3) {
					push(@arrFaces, $_);
				}
	   }
	   my $intRandFace = $arrFaces[rand(@arrFaces)];
	   return $intRandFace;
}

method generateRandomNeck {
	   my @arrNecks = ();
	   foreach (keys %{$self->{child}->{modules}->{crumbs}->{itemCrumbs}}) {
				if ($self->{child}->{modules}->{crumbs}->{itemCrumbs}->{$_}->{type} == 4) {
					push(@arrNecks, $_);
				}
	   }
	   my $intRandNeck = $arrNecks[rand(@arrNecks)];
	   return $intRandNeck;
}

method generateRandomBody {
	   my @arrBodies = ();
	   foreach (keys %{$self->{child}->{modules}->{crumbs}->{itemCrumbs}}) {
				if ($self->{child}->{modules}->{crumbs}->{itemCrumbs}->{$_}->{type} == 5) {
					push(@arrBodies, $_);
				}
	   }
	   my $intRandBody = $arrBodies[rand(@arrBodies)];
	   return $intRandBody;
}


method generateRandomHand {
	   my @arrHands = ();
	   foreach (keys %{$self->{child}->{modules}->{crumbs}->{itemCrumbs}}) {
				if ($self->{child}->{modules}->{crumbs}->{itemCrumbs}->{$_}->{type} == 6) {
					push(@arrHands, $_);
				}
	   }
	   my $intRandHand = $arrHands[rand(@arrHands)];
	   return $intRandHand;
}

method generateRandomFeet {
	   my @arrFeet = ();
	   foreach (keys %{$self->{child}->{modules}->{crumbs}->{itemCrumbs}}) {
				if ($self->{child}->{modules}->{crumbs}->{itemCrumbs}->{$_}->{type} == 7) {
					push(@arrFeet, $_);
				}
	   }
	   my $intRandFeet = $arrFeet[rand(@arrFeet)];
	   return $intRandFeet;
}

method generateRandomName {
		my $strRandPers = Data::RandomPerson->new()->create()->{firstname};
		return $strRandPers;
}

method buildBotString {
	   my $intID = 0;
	   my $strName = $self->generateRandomName;
	   my $intBitMask = 1;
	   my $strColor = "0x". $self->generateRandomColor;
	   my $intHead = $self->generateRandomHead;
	   my $intFace = $self->generateRandomFace;
	   my $intNeck = $self->generateRandomNeck;
	   my $intBody = $self->generateRandomBody;
	   my $intHand = $self->generateRandomHand;
	   my $intFeet = $self->generateRandomFeet;
	   my @arrDetails = (
					$intID, # string id: 0
					$strName, # string id: 1
					$intBitMask, # string id: 2
					$strColor, # string id: 3
					$intHead, # string id: 4
					$intFace, # string id: 5
					$intNeck, # string id: 6
					$intBody, # string id: 7
					$intHand, # string id: 8
					$intFeet, # string id: 9
					0, 0, 0, 0, 0, 1, 999, # string id: 10 - flag, 11 - photo, 12 - xpos, 13 -ypos, 14 -frame, 15 - language, 16 - rank
					'Welcome to the server', #mood - string id: 17
					'000000', #ng - string id: 18
					'FFFFFF', #nc - string id: 19
					'', #bc - string id: 20
					'', #bubbleglow - string id: 21
					'000000', #rc - string id: 22
					10, #speed - string id: 23
					'dQw4w9WgXcQ', #playercard_music - string id: 24
					'', #penguin glow - string id: 25
					'000000', #moodglow - string id: 26
					'FFFFFF', #moodcolor - string id: 27
					'', #snowballglow - string id: 28
					0, #walk on walls - string id: 29
					360, #rotation - string id: 30
					'', #playercard hue - string id: 31
					100, #penguin size - string id: 32
					'{"r":["0","2","MystCP"]}', #marry/bff - string id: 33
					6, #badge - string id: 34
					90000, #tokens, - string id: 35
					'69:69:69:69:69:69' #items hue - string id: 36 - format: #{"head": 66, "face": 66, "neck": 66, "body": 66, "hand": 66, "feet": 66}				
	   );
	   my $strInfo = join('|', @arrDetails);
	   return $strInfo;
}

method handleLoadBot($strData, $objClient) {
       $objClient->sendRoom('%xt%ap%-1%' . $self->buildBotString . '%');
}

method handleReloadBot($objClient, $nullVar) {
       $objClient->sendRoom('%xt%ap%-1%' . $self->buildBotString . '%');
}

method handleBotCommands($strData, $objClient) {
	   my @arrData = split('%', $strData);
	   my $strMsg = $arrData[6];
	   my $chrCmd = substr($strMsg, 0, 1);
	   my $blnBot = $chrCmd eq '~' ? 1 : 0;
	   return if (!$blnBot);
	   my @arrParts = split(' ', substr($strMsg, 1), 2);
       my $strCmd = lc($arrParts[0]);
       my $strArgs = $arrParts[1];
       return if (!exists($self->{commands}->{$strCmd}));
       my $strHandler = $self->{commands}->{$strCmd};
       if ($objClient->{isStaff}) {
           $self->$strHandler($objClient, $strArgs);
       }
}

method handleMoveBot($objClient, $strArgs) {
	   my ($intX, $intY) = split(' ', $strArgs);
	   $objClient->sendRoom('%xt%sp%-1%0%' . ($intX ? $intX : 0) . '%' . ($intY ? $intY : 0) . '%');
}

method handleDance($objClient, $nullVar) {        
		$objClient->sendRoom('%xt%upc%-1%0%0%');
		$objClient->sendRoom('%xt%uph%-1%0%0%');
		$objClient->sendRoom('%xt%upf%-1%0%0%');
		$objClient->sendRoom('%xt%upn%-1%0%0%');
		$objClient->sendRoom('%xt%upb%-1%0%0%');
		$objClient->sendRoom('%xt%upa%-1%0%5016%');
		$objClient->sendRoom('%xt%upe%-1%0%0%');
		$objClient->sendRoom('%xt%upl%-1%0%0%');
		$objClient->sendRoom('%xt%upp%-1%0%0%');
		$objClient->botSay('Turn down for what');
		$objClient->sendRoom('%xt%sf%-1%0%26%');
}

method handleSitDown($objClient, $nullVar) {
	   $objClient->sendRoom('%xt%sf%-1%0%24%');
}

method handle8BallQuestions($objClient, $strQuestion) {
		return if (!$strQuestion);
		my $strAnswer = get("https://api.rtainc.co/twitch/8ball/" . uri_escape($strQuestion));
		$objClient->botSay($strAnswer);
}

method handleSayRandomJoke($objClient, $strQuestion) {
		my $strURL = "http://tambal.azurewebsites.net/joke/random";
		my $arrData = decode_json(get($strURL));
		my $strJoke = $arrData->{joke};
		$objClient->botSay($strJoke);
}

method handleSlackPenguin($objClient, $strUsername) {
		return if (!$strUsername);
		my $strURL = "http://api.icndb.com/jokes/random?firstName=$strUsername";
		my $arrData = decode_json(get($strURL));
		my $strInsult = $arrData->{value}->{joke};
		$strInsult =~ s/Norris//gi;
		$strInsult =~ s/$strUsername /$strUsername/gi;
		$objClient->botSay($strInsult);
}

method handleYoMommaJokes($objClient, $nullVar) {
		my $strURL = "http://api.yomomma.info/";
		my $arrData = decode_json(get($strURL));
		my $strJoke = $arrData->{joke};
		$objClient->botSay($strJoke);
}

method handleFortuneCookie($objClient, $nullVar) {
		my $strURL = "http://fortunecookieapi.com/v1/cookie";
		my $arrData = decode_json(get($strURL));
		my $strMessage = $arrData->[0]->{fortune}->{message};
		$objClient->botSay($strMessage);
}

method handleGiveAdvice($objClient, $nullVar) {
		my $strURL = "http://api.adviceslip.com/advice";
		my $arrData = decode_json(get($strURL));
		my $strAdvice = $arrData->{slip}->{advice};
		$objClient->botSay($strAdvice);
}

method handleUrbanDictionary($objClient, $strQuery) {
		return if (!$strQuery);
		my $resUD = WebService::UrbanDictionary->new;
		my $arrResult = $resUD->request($strQuery); 
		if ($arrResult->result_type ne "no_results") {
			$objClient->botSay($strQuery . ":\n" . $arrResult->definition);
		} else {
			$objClient->botSay("Could not find a definition for this word, try another one!");
		}
}

1;
