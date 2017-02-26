package Stamps;

use strict;
use warnings;

use Method::Signatures;

method new($resChild) {
       my $obj = bless {}, $self;
       $obj->{child} = $resChild;
       return $obj;
}

method handleSendStampEarned($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $intStamp = $arrData[5];
       $objClient->addStamp($intStamp);
}

method handleGetPlayersStamps($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $intPID = $arrData[5];
       return if (!int($intPID));
       my $strStamps = $self->{child}->{modules}->{mysql}->getStampsByID($intPID);
       $objClient->sendXT(['gps', '-1', $intPID, $strStamps]);
}

method handleGetMyRecentlyEarnedStamps($strData, $objClient) {
       my $intID = $objClient->{ID};
       my $strREStamps = $self->{child}->{modules}->{mysql}->getRestampsByID($intID);
       $objClient->sendXT(['gmres', '-1', $intID, $strREStamps]);
       $self->{child}->{modules}->{mysql}->updateTable('users', 'restamps', '', 'ID', $intID);
}

method handleGetStampBookCoverDetails($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $intPID = $arrData[5];
       return if (!int($intPID));
       my $strCover = $self->{child}->{modules}->{mysql}->getStampbookCoverByID($intPID);
       $objClient->write('%xt%gsbcd%-1%' . ($strCover ? $strCover : '1%1%1%1%'));     
}

method handleSetStampBookCoverDetails($strData, $objClient) {
       my @arrData = split('%', $strData);
       my @arrCover;
       while (my ($intKey, $intValue) = each(@arrData)) {
              if ($intKey > 4) {
                  push(@arrCover, $intValue);
              }
       }
       my $strCover = join('%', @arrCover);
       $self->{child}->{modules}->{mysql}->updateTable('users', 'cover', $strCover, 'ID', $objClient->{ID});
       $objClient->write('%xt%ssbcd%-1%' . ($strCover ? $strCover : '%'));
}

1;
