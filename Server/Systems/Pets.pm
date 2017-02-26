package Pets;

use strict;
use warnings;

use Method::Signatures;

method new($resChild) {
       my $obj = bless {}, $self;
       $obj->{child} = $resChild;
       return $obj;
}

method handleAdoptPuffle($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $puffleID = $arrData[5];
       my $puffleName = $arrData[6];
       if ($objClient->{coins} < 800) {
           return $objClient->sendError(401);
       }
       my $puffleString = $objClient->addPuffle($puffleID, $puffleName);
       my $adoptTime = time;
       my $postcardType = 111;
       my $postcardID = $objClient->sendPostcard($objClient->{ID}, 'sys', 0, $puffleName, $postcardType, $adoptTime);
       $objClient->sendXT(['mr', '-1', 'sys', 0, $postcardType, $puffleName, $adoptTime, $postcardID]);
       $objClient->sendXT(['pn', '-1', $objClient->{coins}, $puffleString]);
       $objClient->sendXT(['pgu', '-1', $objClient->getPuffles($objClient->{ID})]);
}

method handleGetPuffle($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $playerID = $arrData[5];
       return if (!int($playerID));
       $objClient->getPufflesByID($playerID);
}

method handlePuffleBath($strData, $objClient) { 
       my @arrData = split('%', $strData);
       my $puffleID = $arrData[5];
       return if (!int($puffleID));
       if ($objClient->{coins} < 5) {
           return $objClient->sendError(401);
       }
       $objClient->changeRandPuffStat($puffleID);
       $objClient->changePuffleStats($puffleID, 'puffleHealth', $self->{child}->{modules}->{crypt}->generateInt(8, 13), 1);
       $objClient->changePuffleStats($puffleID, 'puffleRest', $self->{child}->{modules}->{crypt}->generateInt(13, 20), 1);
       $objClient->setCoins($objClient->{coins} - 5);
       my $petDetails = $objClient->getPuffle($puffleID);
       $objClient->sendRoom('%xt%pb%-1%' . $objClient->{coins} . '%' . ($petDetails ? $petDetails : '%'));
}

method handlePuffleFeed($strData, $objClient) { 
       my @arrData = split('%', $strData);
       my $puffleID = $arrData[5];
       my $intAction = $arrData[6];
       return if (!int($puffleID));
       return if (!int($intAction));
       if ($objClient->{coins} < 5) {
           return $objClient->sendError(401);
       }
       $objClient->changeRandPuffStat($puffleID);
       $objClient->changePuffleStats($puffleID, 'puffleHealth', $self->{child}->{modules}->{crypt}->generateInt(3, 10), 1);
       $objClient->changePuffleStats($puffleID, 'puffleEnergy', $self->{child}->{modules}->{crypt}->generateInt(7, 12), 1);
       $objClient->changePuffleStats($puffleID, 'puffleRest', $self->{child}->{modules}->{crypt}->generateInt(1, 7), 1);
       $objClient->setCoins($objClient->{coins} - 5);
       my $petDetails = $objClient->getPuffle($puffleID);
       $objClient->sendRoom('%xt%pt%-1%' . $objClient->{coins} . '%' . ($petDetails ? $petDetails : '%') . $intAction . '%');
}

method handlePuffleRest($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $puffleID = $arrData[5];
       return if (!int($puffleID));
       $objClient->changePuffleStats($puffleID, 'puffleHealth', $self->{child}->{modules}->{crypt}->generateInt(6, 14), 1);
       $objClient->changePuffleStats($puffleID, 'puffleRest', $self->{child}->{modules}->{crypt}->generateInt(14, 19), 1);
       $objClient->changePuffleStats($puffleID, 'puffleEnergy', $self->{child}->{modules}->{crypt}->generateInt(7, 15), 1);
       my $petDetails = $objClient->getPuffle($puffleID);
       $objClient->sendRoom('%xt%pr%-1%' . ($petDetails ? $petDetails : '%'));
}

method handlePufflePip($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $puffleID = $arrData[5];
       return if (!int($puffleID) || !int($arrData[6]) || !int($arrData[7]));
       my $petDetails = $self->{child}->{modules}->{mysql}->getPuffleByOwner($puffleID, $objClient->{ID});
       $objClient->sendRoom('%xt%pir%-1%' . $petDetails->{puffleID} . '%' . $arrData[6] . '%' . $arrData[7] . '%');
}

method handlePufflePlay($strData, $objClient) { 
       my @arrData = split('%', $strData);
       my $puffleID = $arrData[5];
       return if (!int($puffleID));
       $objClient->changePuffleStats($puffleID, 'puffleEnergy', $self->{child}->{modules}->{crypt}->generateInt(5, 10), 0);
       $objClient->changePuffleStats($puffleID, 'puffleRest', $self->{child}->{modules}->{crypt}->generateInt(5, 12), 0);
       $objClient->changePuffleStats($puffleID, 'puffleHealth', $self->{child}->{modules}->{crypt}->generateInt(4, 10), 1);
       my $petDetails = $objClient->getPuffle($puffleID);
       $objClient->sendRoom('%xt%pp%-1%' . ($petDetails ? $petDetails : '%') . int(rand(2)) . '%');
}

method handlePuffleFeedFood($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $puffleID = $arrData[5];
       return if (!int($puffleID));
       if ($objClient->{coins} < 10) {
           return $objClient->sendError(401);
       }
       $objClient->changeRandPuffStat($puffleID);
       $objClient->changePuffleStats($puffleID, 'puffleHealth', $self->{child}->{modules}->{crypt}->generateInt(3, 10), 1);
       $objClient->changePuffleStats($puffleID, 'puffleEnergy', $self->{child}->{modules}->{crypt}->generateInt(7, 12), 1);
       $objClient->changePuffleStats($puffleID, 'puffleRest', $self->{child}->{modules}->{crypt}->generateInt(1, 7), 1);
       $objClient->setCoins($objClient->{coins} - 10);
       my $petDetails = $objClient->getPuffle($puffleID);
       $objClient->sendRoom('%xt%pf%-1%' . $objClient->{coins} . '%' . ($petDetails ? $petDetails : '%'));
}

method handlePufflePir($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $puffleID = $arrData[5];
       return if (!int($puffleID) || !int($arrData[6]) || !int($arrData[7]));
       my $petDetails = $self->{child}->{modules}->{mysql}->getPuffleByOwner($puffleID, $objClient->{ID});
       $objClient->sendRoom('%xt%pir%-1%' . $petDetails->{puffleID} . '%' . $arrData[6] . '%' . $arrData[7] . '%');
}

method handlePuffleMove($strData, $objClient) {
       my @arrData = split('%', $strData);
       $objClient->sendRoom('%xt%pm%-1%' . $arrData[5] . '%' . $arrData[6] . '%' . $arrData[7] . '%');
}

method handlePuffleUser($strData, $objClient) {
       $objClient->sendXT(['pgu', '-1', $objClient->getPuffles($objClient->{ID})]);
}           

method handlePuffleIsPlaying($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $puffleID = $arrData[5];
       return if (!int($puffleID) || !int($arrData[6]) || !int($arrData[7]));
       my $petDetails = $objClient->getPuffle($puffleID);
       $objClient->sendRoom('%xt%ip%-1%' . ($petDetails ? $petDetails : '%') . $arrData[6] . '%' . $arrData[7] . '%');
}

method handlePuffleIsFeeding($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $puffleID = $arrData[5];
       return if (!int($puffleID) || !int($arrData[6]) || !int($arrData[7]));
       my $petDetails = $objClient->getPuffle($puffleID);
       $objClient->sendRoom('%xt%if%-1%' . $objClient->{coins} . '%' . ($petDetails ? $petDetails : '%') . $arrData[6] . '%' . $arrData[7] . '%');
}

method handlePuffleIsResting($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $puffleID = $arrData[5];
       return if (!int($puffleID) || !int($arrData[6]) || !int($arrData[7]));
       my $petDetails = $objClient->getPuffle($puffleID);
       $objClient->sendRoom('%xt%ir%-1%' . ($petDetails ? $petDetails : '%') . $arrData[6] . '%' . $arrData[7] . '%');
}

method handleSendPuffleFrame($strData, $objClient) {
       my @arrData = split('%', $strData);
       $objClient->sendRoom('%xt%ps%-1%' . $arrData[5] . '%' . $arrData[6] . '%'); # puffle id / puffle frame ?
}

method handlePuffleWalk($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $puffleID = $arrData[5];
       my $blnWalk = $arrData[6];
       return if (!int($puffleID));
       return if (!int($blnWalk));
       my $arrWalkingPuffle = $self->{child}->{modules}->{mysql}->getWalkingPuffle($objClient->{ID});
	   $self->{child}->{modules}->{mysql}->updateWalkingPuffle(0, $arrWalkingPuffle->{puffleID}, $objClient->{ID});
       my $petDetails = $self->{child}->{modules}->{mysql}->getPuffleByOwner($puffleID, $objClient->{ID});
       if ($petDetails) {
           my $walkStr = $petDetails->{puffleID} . '|' . $petDetails->{puffleName} . '|' . $petDetails->{puffleType} . '|' . $petDetails->{puffleHealth} . '|' . $petDetails->{puffleEnergy} . '|' . $petDetails->{puffleRest} . '|0|0|0|0|0|0'; # Dont know what the rest are
           if ($blnWalk eq 1) {
               $objClient->updatePlayerCard('upa', 'hand', 75 . $petDetails->{puffleType});
               $self->{child}->{modules}->{mysql}->updateWalkingPuffle(1, $petDetails->{puffleID}, $objClient->{ID});
               $objClient->sendRoom('%xt%pw%-1%' . $objClient->{ID} . '%' . $walkStr . '|1%');
           } else {
               $objClient->updatePlayerCard('upa', 'hand', 0);
               $self->{child}->{modules}->{mysql}->updateWalkingPuffle(1, $petDetails->{puffleID}, $objClient->{ID});
               $objClient->sendRoom('%xt%pw%-1%' . $objClient->{ID} . '%' . $walkStr . '|0%');
           }
       }
       $objClient->getPuffles($objClient->{ID});
}

1;
