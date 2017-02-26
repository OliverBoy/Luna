package Player;

use strict;
use warnings;

use Method::Signatures;

method new($resChild) {
       my $obj = bless {}, $self;
       $obj->{child} = $resChild;
       return $obj;
}

method handleSetFrame($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $intFrame = $arrData[5];
       $objClient->setFrame($intFrame);
}

method handleSendEmote($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $intEmote = $arrData[5];
       $objClient->sendEmote($intEmote);
}

method handleSendAction($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $intAction = $arrData[5];
       $objClient->setAction($intAction);
}

method handleSendSafe($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $intMsg = $arrData[5];
       $objClient->sendSafeMsg($intMsg);
}

method handleSendGuide($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $intMsg = $arrData[5];
       $objClient->sendTourMsg($intMsg);
}

method handleSendJoke($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $intJoke = $arrData[5];
       $objClient->sendJoke($intJoke);
}

method handleSendMascot($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $intMsg = $arrData[5];
       $objClient->sendMascotMsg($intMsg);
}

method handleSetPosition($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $intX = $arrData[5];
       my $intY = $arrData[6];
       $objClient->setPosition($intX, $intY);
}

method handleSnowball($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $intX = $arrData[5];
       my $intY = $arrData[6];
       $objClient->throwSnowball($intX, $intY);
}

method handleGetLatestRevision($strData, $objClient) {
       $objClient->getLatestRevision;
}
          
method handleGetPlayer($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $intID = $arrData[5];
       $objClient->getPlayer($intID);
}

method handleHeartbeat($strData, $objClient) {
       $objClient->sendHeartBeat;
}

1;
