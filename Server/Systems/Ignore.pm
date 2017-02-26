package Ignore;

use strict;
use warnings;

use Method::Signatures;

method new($resChild) {
       my $obj = bless {}, $self;
       $obj->{child} = $resChild;
       return $obj;
}

method handleGetIgnored($strData, $objClient) {
       my $strIgnored = $self->handleFetchIgnored($objClient);
       $objClient->write('%xt%gn%-1%' . ($strIgnored ? $strIgnored : '%'));
}

method handleAddIgnore($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $intPID = $arrData[5];
       return if (!int($intPID) && exists($objClient->{ignored}->{$intPID}));
       $objClient->{ignored}->{$intPID} = $objClient->{username};
       my $strIgnored = join(',', map { $_ . '|' . $objClient->{ignored}->{$_}; } keys %{$objClient->{ignored}});
       $self->{child}->{modules}->{mysql}->updateTable('users', 'ignored', $strIgnored, 'ID', $objClient->{ID});
       $objClient->sendXT(['an', $objClient->{room}, $intPID]);
}

method handleRemoveIgnored($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $intPID = $arrData[5];
       return if (!int($intPID) && !exists($objClient->{ignored}->{$intPID}));
       delete($objClient->{ignored}->{$intPID});
       my $strIgnored = join(',', map { $_ . '|' . $objClient->{ignored}->{$_}; } keys %{$objClient->{ignored}});
       $self->{child}->{modules}->{mysql}->updateTable('users', 'ignored', $strIgnored, 'ID', $objClient->{ID});
       $objClient->sendXT(['rn', $objClient->{room}, $intPID]);
}

method handleFetchIgnored($objClient) {
       my $strIgnored = join('%', map { $_ . '|' . $objClient->{ignored}->{$_}; } keys %{$objClient->{ignored}});
       return $strIgnored;
}

1;
