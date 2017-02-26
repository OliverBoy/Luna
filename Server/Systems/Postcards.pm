package Postcards;

use strict;
use warnings;

use Method::Signatures;
use HTTP::Date qw(str2time);
use HTML::Entities;

method new($resChild) {
       my $obj = bless {}, $self;
       $obj->{child} = $resChild;
       return $obj;
}

method handleMailGet($strData, $objClient) {
       my $strCards = $objClient->getPostcards($objClient->{ID});
       $objClient->write('%xt%mg%-1%' . ($strCards ? $strCards : '%'));
}

method handleMailStart($strData, $objClient) {
       my $unreadCount = $objClient->getUnreadPostcards($objClient->{ID});
       my $postcardCount = $objClient->getPostcardCount($objClient->{ID});
       $objClient->sendXT(['mst', '-1', $unreadCount, $postcardCount]);
}

method handleMailSend($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $recepientID = $arrData[5];
       my $postcardType = $arrData[6];
       my $postcardNotes = decode_entities(($arrData[7] ? $arrData[7] : ''));
       return if (!int($recepientID) || !int($postcardType) || !defined($postcardNotes));
       return if (!exists($self->{child}->{modules}->{crumbs}->{mailCrumbs}->{$postcardType}));
       if ($objClient->{coins} < 10) {
           $objClient->sendXT(['ms', '-1', $objClient->{coins}, 2]);
       } else {
           my $objPlayer = $objClient->getClientByID($recepientID);
           my $timestamp = time;
           my $postcardID = $objClient->sendPostcard($recepientID, $objClient->{username}, $objClient->{ID}, $postcardNotes, $postcardType, $timestamp);
           if ($objClient->getOnline($recepientID)) {
               $objPlayer->write('%xt%mr%-1%' . $objClient->{username} . '%' . $objClient->{ID} . '%' . $postcardType . '%%' . $timestamp . '%' . $postcardID . '%');
               $objClient->sendXT(['ms', '-1', $objClient->{coins}, 1]);
           } else {
			   $objClient->sendXT(['ms', '-1', $objClient->{coins}, 1]);
		   }
		   $objClient->setCoins($objClient->{coins} - 10);
       }
}

method handleMailChecked($strData, $objClient) {
       $self->{child}->{modules}->{mysql}->updateTable('postcards', 'isRead', 1, 'recepient', $objClient->{ID});
       $objClient->sendXT(['mc', '-1', 1]);
}

method handleMailDelete($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $postcardID = $arrData[5];
       return if (!int($postcardID));
       $self->{child}->{modules}->{mysql}->deleteData('postcards', 'postcardID', $postcardID, 0, '', '');
       $objClient->sendXT(['md', '-1', $postcardID]);
}

method handleMailDeletePlayer($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $playerID = $arrData[5];
       return if (!int($playerID));
       $self->{child}->{modules}->{mysql}->deleteData('postcards', 'recepient', $objClient->{ID}, 1, 'mailerID', $playerID);
       my $intCount = $objClient->getPostcardCount($objClient->{ID});
       $objClient->sendXT(['mdp', '-1', $intCount]);
}	
       	     
1;
