package Bot;

use strict;
use warnings;

use Method::Signatures;

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
       $obj->{botProp} = {
		    Prefix => '>',
			ID => 0,
			Name => 'Mystic',
			bitMask => 1,
			Color => '0x866DCA',
			Head => 413,
			Face => 410,
			Neck => 161,
			Body => 0,
			Hand => 754,
			Feet => 0,
			Flag => 0,
			Photo => 0, 0, 0, 0, 1,
			Rank => 999,
			NameGlow => '0xA92A98',
			NameColour => '0xFFFFFF',
			BubbleColour => '0x0B99A9',
			BubbleText => '0xFFFFFF',
			RingColour => '',
			Speed => 10,
			Title => 'Host',
			Mood => 'This job bloody sucks',
			ChatGlow => '',
			PenguinGlow => '',
			BubbleGlow => '',
			MoodGlow => '0x000000',
			MoodColor => '0xFFFFFF',
		    SnowballGlow => '0x75158D',
		    Wow => 1,
		    Transformation => '',
		    TitleGlow => '0xA91700',
			TitleColor => '0xFFFFFF'
	   };
	   $obj->{commands} = {
		      move => 'handleMoveBot',
		      dance => 'handleDance',
		      mwalk => 'handleMoonWalk',
		      sit => 'handleSitDown',
	   };
       return $obj;
}

method buildBotString {
	   my @arrDetails = (
					$self->{botProp}->{ID},
					$self->{botProp}->{Name},
					$self->{botProp}->{bitMask},
					$self->{botProp}->{Color},
					$self->{botProp}->{Head},
					$self->{botProp}->{Face},
					$self->{botProp}->{Neck},
					$self->{botProp}->{Body},
					$self->{botProp}->{Hand},
					$self->{botProp}->{Feet},
					$self->{botProp}->{Photo},
					$self->{botProp}->{Flag}, 1, 0, 0, 0,
					$self->{botProp}->{Rank},
					$self->{botProp}->{NameGlow},
					$self->{botProp}->{NameColour},
					$self->{botProp}->{BubbleColour},
					$self->{botProp}->{BubbleText},
					$self->{botProp}->{RingColour},
					$self->{botProp}->{Speed},
					$self->{botProp}->{Title},
					$self->{botProp}->{Mood},
					$self->{botProp}->{ChatGlow},
					$self->{botProp}->{PenguinGlow},
					$self->{botProp}->{BubbleGlow},
					$self->{botProp}->{MoodGlow},
					$self->{botProp}->{MoodColor},
					$self->{botProp}->{SnowballGlow},
					$self->{botProp}->{Wow},
					$self->{botProp}->{Transformation},
					$self->{botProp}->{TitleGlow},
					$self->{botProp}->{TitleColor}
	   );
	   my $strBot = join('|', @arrDetails);
	   return $strBot;
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
	   my $blnMember = $chrCmd eq $self->{botProp}->{Prefix} ? 1 : 0;
	   return if (!$blnMember);
	   my @arrParts = split(' ', substr($strMsg, 1), 2);
       my $strCmd = lc($arrParts[0]);
       my $strArgs = $arrParts[1];
       return if (!exists($self->{commands}->{$strCmd}));
       my $strHandler = $self->{commands}->{$strCmd};
       $self->$strHandler($objClient, $strArgs);
}

method handleMoveBot($objClient, $strArgs) {
	   $objClient->sendRoom('%xt%sp%-1%0%' .  join('%', split(' ', $strArgs)) . '%');
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
		$objClient->botSay('Watch me break the floor bitches');
		$objClient->sendRoom('%xt%sf%-1%0%26%');
}

method handleMoonWalk($objClient, $nullVar) {
       $objClient->sendRoom('%xt%sf%-1%0%16%');
}

method handleSitDown($objClient, $nullVar) {
	   $objClient->sendRoom('%xt%sf%-1%0%24%');
}

1;
