package Messaging;

use strict;
use warnings;

use Method::Signatures;

method new($resChild) {
       my $obj = bless {}, $self;
       $obj->{child} = $resChild;
       return $obj;
}

method handleSendMessage($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $strMsg = $arrData[6];
       $objClient->sendMessage($strMsg);
}

1;
