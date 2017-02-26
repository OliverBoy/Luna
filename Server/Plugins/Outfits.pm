use strict;
use warnings;

package Outfits;

use Method::Signatures;
use List::MoreUtils qw(firstidx);
use Data::Dumper;

method new($resChild) {
       my $obj = bless {}, $self;
       $obj->{child} = $resChild;
       $obj->{pluginType} = 2;
       $obj->{property} = {
              'm#sm' => { 
                     handler => 'handleOutfitCommands',
                     isEnabled => 1
              }
       };
       $obj->{commands} = {
		      saveoutfit => 'handleSaveCurrentOutfit',
		      gpoutfit => 'handleGetPreviousOutfit',
		      gsoutfit => 'handleGetSavedOutfit'
	   };
       return $obj;
}

method handleOutfitCommands($strData, $objClient) {
	   my @arrData = split('%', $strData);
	   my $strMsg = $arrData[6];
	   my $chrCmd = substr($strMsg, 0, 1);
	   my $blnMember = $chrCmd eq $self->{child}->{servConfig}->{userPrefix} ? 1 : 0;
	   return if (!$blnMember);
	   my @arrParts = split(' ', substr($strMsg, 1), 2);
       my $strCmd = lc($arrParts[0]);
       my $strArg = $arrParts[1];
       return if (!exists($self->{commands}->{$strCmd}));
       my $strHandler = $self->{commands}->{$strCmd};
       $self->$strHandler($objClient, $strArg);
}

method handleSaveCurrentOutfit($objClient, $strName) {
	   return if ($strName !~ /^[a-zA-Z0-9]+$/);
	   return if ($self->outfitExists($objClient, $strName));
	   my @arrClothes = (
	                  ($objClient->{colour} ? $objClient->{colour} : 0),
                      ($objClient->{head} ? $objClient->{head} : 0),
                      ($objClient->{face} ? $objClient->{face} : 0),
                      ($objClient->{neck} ? $objClient->{neck} : 0),
                      ($objClient->{body} ? $objClient->{body} : 0),
                      ($objClient->{hand} ? $objClient->{hand} : 0),
                      ($objClient->{feet} ? $objClient->{feet} : 0), 
                      ($objClient->{flag} ? $objClient->{flag} : 0), 
                      ($objClient->{photo} ? $objClient->{photo} : 0)
	   );	   
	   my $dbInfo = $self->{child}->{modules}->{mysql}->fetchColumns("SELECT `outfits` FROM users WHERE `ID` = '$objClient->{ID}'");
	   my $strOutfits = $dbInfo->{outfits};
	   $strOutfits .= $strName . '|' . join('|', @arrClothes) . ',';
	   $self->{child}->{modules}->{mysql}->updateTable('users', 'outfits', $strOutfits, 'ID', $objClient->{ID});
}

method outfitExists($objClient, $strName) {
	   my $dbInfo = $self->{child}->{modules}->{mysql}->fetchColumns("SELECT `outfits` FROM users WHERE `ID` = '$objClient->{ID}'");
	   my @arrOutfits = split(',', $dbInfo->{outfits});
	   foreach my $strOutfit (@arrOutfits) {
		  my @arrClothing = split('\\|', $strOutfit);
		  my $strOutfitName = $arrClothing[0];
		  if (uc($strName) eq uc($strOutfitName)) {
			  return 1;
	      } else {
			  return 0;
		  }
	   }
	   
}

method handleGetPreviousOutfit($objClient, $nullVar)  {
	   my $dbInfo = $self->{child}->{modules}->{mysql}->fetchColumns("SELECT `outfits` FROM users WHERE `ID` = '$objClient->{ID}'");
	   my @arrOutfits = split(',', $dbInfo->{outfits});
	   my $strLastOutfit = $arrOutfits[-1];
	   my @arrClothing = split('\\|', $strLastOutfit);
	   $objClient->updatePlayerCard('upc', 'colour', $arrClothing[1]);
	   $objClient->updatePlayerCard('uph', 'head', $arrClothing[2]);
	   $objClient->updatePlayerCard('upf', 'face', $arrClothing[3]);
	   $objClient->updatePlayerCard('upn', 'neck', $arrClothing[4]);
	   $objClient->updatePlayerCard('upb', 'body', $arrClothing[5]);
	   $objClient->updatePlayerCard('upa', 'hand', $arrClothing[6]);
	   $objClient->updatePlayerCard('upe', 'feet', $arrClothing[7]);
	   $objClient->updatePlayerCard('upl', 'flag', $arrClothing[8]);
	   $objClient->updatePlayerCard('upp', 'photo', $arrClothing[9]);
}

method handleGetSavedOutfit($objClient, $strName)  {
	   my $dbInfo = $self->{child}->{modules}->{mysql}->fetchColumns("SELECT `outfits` FROM users WHERE `ID` = '$objClient->{ID}'");
	   my @arrOutfits = split(',', $dbInfo->{outfits});
	   foreach my $strOutfit (@arrOutfits) {
	           my @arrClothing = split('\\|', $strOutfit);
	           my $strOutfitName = $arrClothing[0];
	           if (uc($strName) eq uc($strOutfitName)) {
				   $objClient->updatePlayerCard('upc', 'colour', $arrClothing[1]);
				   $objClient->updatePlayerCard('uph', 'head', $arrClothing[2]);
				   $objClient->updatePlayerCard('upf', 'face', $arrClothing[3]);
				   $objClient->updatePlayerCard('upn', 'neck', $arrClothing[4]);
				   $objClient->updatePlayerCard('upb', 'body', $arrClothing[5]);
				   $objClient->updatePlayerCard('upa', 'hand', $arrClothing[6]);
				   $objClient->updatePlayerCard('upe', 'feet', $arrClothing[7]);
				   $objClient->updatePlayerCard('upl', 'flag', $arrClothing[8]);
                   $objClient->updatePlayerCard('upp', 'photo', $arrClothing[9]);                  
			  }
	  }
}

1;
