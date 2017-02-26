package Tables;

use strict;
use warnings;

use Method::Signatures;

method new($resChild) {
       my $obj = bless {}, $self;
       $obj->{child} = $resChild;
       $obj->{boardMap} = [[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0]];
       $obj->{matches} = $resChild->{modules}->{matches};
       return $obj;
}

method handleJoinTable($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $intTable = $arrData[5];
       if ($self->{matches}->addToTable($intTable, $objClient)) {
           $self->{matches}->{tables}->{$intTable}->{boardMap} = $self->{boardMap};
           $objClient->sendXT(['jt', '-1', $objClient->{tableID}, $objClient->{seatID}]);
       } else {
           $objClient->sendError(211);
       }
}

method handleGetTable($strData, $objClient) {
       my @arrData = split('%', $strData);
       splice(@arrData, 0, 5);
       my $tablePopulation = '';
       foreach (@arrData) {
                if (defined($self->{matches}->getTable($_))) {
                    $tablePopulation .= $_ . '|' . $self->{matches}->getTableClientCount($_) . '%';
                }
       }
       $objClient->sendXT(['gt', '-1', substr($tablePopulation, 0, -1)]);
}

method handleUpdateTable($strData, $objClient) {
       my @arrData = split('%', $strData);
       $objClient->sendRoom('%xt%ut%' . $arrData[5] . '%' . $arrData[6] . '%');
}

method handleLeaveTable($strData, $objClient) {
       if ($objClient->{room} eq 220 || $objClient->{room} eq 221) {
           if ($objClient->{tableID} ne 0 && $objClient->{seatID} ne 999) {
               foreach (values %{$self->{matches}->getTable($objClient->{tableID})->{clients}}) {
                        if ($_->{ID} ne $objClient->{ID}) {
                            $_->sendXT(['cz', '-1', $objClient->{username}]);
                        }
                        $self->{matches}->removeFromTable($_->{tableID}, $_->{seatID});
                        $_->{tableID} = 0;
                        $_->{seatID} = 0;
               }
               $self->{matches}->removeFromTable($objClient->{tableID}, $objClient->{tableID});
               $objClient->{tableID} = 0;
               $objClient->{seatID} = 999;
          }
      }
}

1;
