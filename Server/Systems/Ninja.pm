package Ninja;

use strict;
use warnings;

use Method::Signatures;

method new($resChild) {
       my $obj = bless {}, $self;
       $obj->{child} = $resChild;
       return $obj;
}

method handleGetNinjaRanks($strData, $objClient) {
       my @arrData = split('%', $strData);
       $objClient->sendXT(['gnr', '-1', $arrData[5], '0', '0', '0', '0']); #arrData[5] being player id, later?
}

method handleGetNinjaLevel($strData, $objClient) {
       $objClient->sendXT(['gnl', '-1', '0', '0']); # Level (BELT) // % To Next Level
}

method handleGetCards($strData, $objClient) {
       $objClient->sendXT(['gcd', '-1']); # %xt%gcd%-1%101,1|102,1|card_id,card_quantity% ; later...
}

method handleGetFireLevel($strData, $objClient) {
       $objClient->sendXT(['gfl', '-1', '0', '0']); # Level (BELT) // % To Next Level
}

method handleGetWaterLevel($strData, $objClient) {
       $objClient->sendXT(['gwl', '-1', '0', '0']); # Level (BELT) // % To Next Level
}

method handleGetSnowLevel($strData, $objClient) {
       $objClient->sendXT(['gsl', '-1', '0', '0']); # Level (BELT) // % To Next Level
}

1;
