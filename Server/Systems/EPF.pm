package EPF;

use strict;
use warnings;

use Method::Signatures;
use List::Util qw(first);

method new($resChild) {
       my $obj = bless {}, $self;
       $obj->{child} = $resChild;
       return $obj;
}

method handleEPFAddItem($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $intItem = $arrData[5];
       return if (!int($intItem));
       if (!exists($self->{child}->{modules}->{crumbs}->{epfCrumbs}->{$intItem})) {
           return $objClient->sendError(402);
       } elsif (first {$_ == $intItem} @{$objClient->{inventory}}) {
           return $objClient->sendError(400);
       } elsif ($objClient->{epfPoints} < $self->{child}->{modules}->{crumbs}->{epfCrumbs}->{$intItem}->{points}) {
           return $objClient->sendError(405);
       }
       push(@{$objClient->{inventory}}, $intItem);
       $self->{child}->{modules}->{mysql}->updateTable('users', 'inventory', join('%', @{$objClient->{inventory}}), 'ID', $objClient->{ID});
       $objClient->updateEPFPoints($objClient->{epfPoints} - $self->{child}->{modules}->{crumbs}->{epfCrumbs}->{$intItem}->{points});
       $objClient->sendXT(['epfai', '-1', $intItem, $objClient->{epfPoints}]);
}

method handleEPFGetAgent($strData, $objClient) {
	      $objClient->sendXT(['epfga', '-1', $objClient->{isEPF}]);
}

method handleEPFGetRevision($strData, $objClient) {
	      $objClient->sendXT(['epfgr', '-1', $objClient->{totalEPFPoints}, $objClient->{epfPoints}]);
}

method handleEPFGetField($strData, $objClient) {
	      $objClient->sendXT(['epfgf', '-1', $objClient->{fieldOPStatus}]);
}

method handleEPFSetField($strData, $objClient) {
       $objClient->{fieldOPStatus} ? $objClient->updateOPStat(0) : $objClient->updateOPStat(1);
       $objClient->sendXT(['epfsf', '-1', $objClient->{fieldOPStatus}]);
}

method handleEPFSetAgent($strData, $objClient) {
      if (!$objClient->{isEPF}) {
           $objClient->updateEPF(1);
           $objClient->sendXT(['epfsa', '-1', 1]);
      }
}

method handleEPFGetMessage($strData, $objClient) {
       my @arrInfo = ('u wot m8', time, 15);
       $objClient->sendXT(['epfgm', '-1', $objClient->{ID}, join('|', @arrInfo)]);
}

1;