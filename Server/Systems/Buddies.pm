package Buddies;

use strict;
use warnings;

use Method::Signatures;

method new($resChild) {
       my $obj = bless {}, $self;
       $obj->{child} = $resChild;
       return $obj;
}

method handleGetBuddies($strData, $objClient) {
       my $strBuddies = $self->handleFetchBuddies($objClient);
       $objClient->write('%xt%gb%-1%' . ($strBuddies ? $strBuddies : '%'));
}

method handleFetchBuddies($objClient) {
       my $strBuddies = join('%', map { $_ . '|' . $objClient->{buddies}->{$_} . '|' . ($objClient->getOnline($_) ? 1 : 0); } keys %{$objClient->{buddies}});
       return $strBuddies;
}


method handleBuddyRequest($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $intBudID = $arrData[5];
       return if (!int($intBudID));
       my $objPlayer = $objClient->getClientByID($intBudID);
       $objPlayer->{buddyRequests}->{$objClient->{ID}} = 1;
       $objPlayer->sendXT(['br', '-1', $objClient->{ID}, $objClient->{username}]);  
}

method handleBuddyAccept($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $intBudID = $arrData[5];
       return if (!int($intBudID) && exists($objClient->{buddies}->{$intBudID}));
       my $objPlayer = $objClient->getClientByID($intBudID);
       delete($objPlayer->{buddyRequests}->{$objClient->{ID}});
       $objClient->{buddies}->{$intBudID} = $objPlayer->{username};
       $objPlayer->{buddies}->{$objClient->{ID}} = $objClient->{username};
       my $strCBuddies = join(',', map { $_ . '|' . $objClient->{buddies}->{$_}; } keys %{$objClient->{buddies}});
       my $strPBuddies = join(',', map { $_ . '|' . $objPlayer->{buddies}->{$_}; } keys %{$objPlayer->{buddies}});
       $self->{child}->{modules}->{mysql}->updateTable('users', 'buddies', $strCBuddies, 'ID', $objClient->{ID});
       $self->{child}->{modules}->{mysql}->updateTable('users', 'buddies', $strPBuddies, 'ID', $objPlayer->{ID});
       $objPlayer->sendXT(['ba', '-1', $objClient->{ID}, $objClient->{username}]);
}

method handleRemoveBuddy($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $intBudID = $arrData[5];
       return if (!int($intBudID) && !exists($objClient->{buddies}->{$intBudID}));
       my $objPlayer = $objClient->getClientByID($intBudID);
       delete($objClient->{buddies}->{$objPlayer->{ID}});
       delete($objPlayer->{buddies}->{$objClient->{ID}});    
       my $strCBuddies = join(',', map { $_ . '|' . $objClient->{buddies}->{$_}; } keys %{$objClient->{buddies}});
       my $strPBuddies = join(',', map { $_ . '|' . $objPlayer->{buddies}->{$_}; } keys %{$objPlayer->{buddies}});
       $self->{child}->{modules}->{mysql}->updateTable('users', 'buddies', $strCBuddies, 'ID', $objClient->{ID});
       $self->{child}->{modules}->{mysql}->updateTable('users', 'buddies', $strPBuddies, 'ID', $objPlayer->{ID});
       $objPlayer->sendXT(['rb', '-1', $objClient->{ID}, $objClient->{username}]);
}

method handleBuddyFind($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $intBudID = $arrData[5];
       return if (!int($intBudID));
       my $objPlayer = $objClient->getClientByID($intBudID);
       $objClient->sendXT(['bf', '-1', $objPlayer->{room}]);
}

1;
