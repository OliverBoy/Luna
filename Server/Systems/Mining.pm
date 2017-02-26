package Mining;

use strict;
use warnings;

use Method::Signatures;

method new($resChild) {
       my $obj = bless {}, $self;
       $obj->{child} = $resChild;
       return $obj;
}

method handleCoinsDigUpdate($strData, $objClient) {
       my $intCoins = $self->{child}->{modules}->{crypt}->generateInt(1, 100);
       $objClient->setCoins($objClient->{coins} + $intCoins);
       $objClient->sendXT(['cdu', '-1', $intCoins, $objClient->{coins}]);
}

1;
