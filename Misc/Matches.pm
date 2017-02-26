package Matches;

use strict;
use warnings;

use Method::Signatures;

method new ($resChild) {
       my $obj = bless {}, $self;
       $obj->{child} = $resChild;
       $obj->{tables} = {
              100 => {clients => {}, max => 2},
              101 => {clients => {}, max => 2},
              102 => {clients => {}, max => 2},
              103 => {clients => {}, max => 2},
              104 => {clients => {}, max => 2},
              200 => {clients => {}, max => 2},
              201 => {clients => {}, max => 2}, 
              202 => {clients => {}, max => 2}, 
              203 => {clients => {}, max => 2},
              204 => {clients => {}, max => 2}, 
              205 => {clients => {}, max => 2},
              206 => {clients => {}, max => 2}, 
              207 => {clients => {}, max => 2},
              300 => {clients => {}, max => 2},
              301 => {clients => {}, max => 2}, 
              302 => {clients => {}, max => 2}, 
              303 => {clients => {}, max => 2},
              304 => {clients => {}, max => 2}, 
              305 => {clients => {}, max => 2},
              306 => {clients => {}, max => 2}, 
              307 => {clients => {}, max => 2}
       };
       $obj->{waddles} = {
              100 => {clients => {}, max => 4},
              101 => {clients => {}, max => 3}, 
              102 => {clients => {}, max => 2}, 
              103 => {clients => {}, max => 2},
              200 => {clients => {}, max => 2}, 
              201 => {clients => {}, max => 2},
              202 => {clients => {}, max => 2}, 
              203 => {clients => {}, max => 2}
       };
       $obj->{matches} = {};
       return $obj;
}

method getTable($tableID) {
       return $self->{tables}->{$tableID};
}

method getWaddle($waddleID) {
       return $self->{waddles}->{$waddleID};
}

method getWaddleClientCount($waddleID) {
       return if (!exists($self->{waddles}->{$waddleID}));
       my $clients = 0;
       foreach (values %{$self->{waddles}->{$waddleID}->{clients}}) {
                if ($_->{waddleID} ne $waddleID) {
                    delete($self->{waddles}->{$waddleID}->{clients}->{$_->{seatID}});
                    next;
                }
                $clients++;
       }
       return $clients;
}

method getTableClientCount($tableID) {
       return if (!exists($self->{tables}->{$tableID}));
       my $clients = 0;
       foreach (values %{$self->{tables}->{$tableID}->{clients}}) {
                if ($_->{tableID} ne $tableID) {
                    delete($self->{tables}->{$tableID}->{clients}->{$_->{seatID}});
                    next;
                }
                $clients++;
       }
       return $clients;
}

method addToTable($tableID, $objClient) {
       if ($self->getTableClientCount($tableID) >= $self->{tables}->{$tableID}->{max} || $objClient->{tableID} ne 0 || !exists($self->{tables}->{$tableID})) {
           return 0;
       }
       $self->{tables}->{$tableID}->{clients}->{$self->getTableClientCount($tableID)} = $objClient;
       $objClient->{tableID} = $tableID;
       $objClient->{seatID} = $self->getTableClientCount($tableID);
       return 1;
}

method joinWaddle($objClient, $waddleID) {
       if ($self->getWaddleClientCount($waddleID) >= $self->{waddles}->{$waddleID}->{max} || $objClient->{waddleID} ne 0 || !exists($self->{waddles}->{$waddleID})) {
           return 0;
       }
       $self->{waddles}->{$waddleID}->{clients}->{$self->getWaddleClientCount($waddleID)} = $objClient;
       $objClient->{waddleID} = $waddleID;
       $objClient->{seatID} = $self->getWaddleClientCount($waddleID) - 1;
       $objClient->sendRoom('%xt%uw%-1%' . $waddleID . '%' . $objClient->{seatID} . '%' . $objClient->{username} . '%' . $objClient->{ID} . '%');
       $objClient->sendXT(['jw', '-1', $objClient->{seatID}]);
       if ($self->getWaddleClientCount($waddleID) >= $self->{waddles}->{$waddleID}->{max}) {
           $self->prepareWaddle($waddleID);
       }
       return 1;
}

method removeFromTable($tableID, $seatID) {
       return if (!exists($self->{tables}->{$tableID}));
       delete($self->{tables}->{$tableID}->{clients}->{$seatID - 1});
}

method leaveWaddle($objClient) {
       return if (!exists($self->{waddles}->{$objClient->{waddleID}}));
       $objClient->sendRoom('%xt%uw%-1%' . $objClient->{waddleID} . '%' . $objClient->{seatID} . '%');
       delete($self->{waddles}->{$objClient->{waddleID}}->{clients}->{$objClient->{seatID} - 1});
       $objClient->{waddleID} = 0;
       $objClient->{seatID} = 999;
}

method resetTable($tableID) {
       return if (!exists($self->{tables}->{$tableID}));
       my $maxClients = $self->{tables}->{$tableID}->{max};
       $self->{tables}->{$tableID} = {clients => {}, max => $maxClients};
}

method resetWaddle($waddleID) {
       return if (!exists($self->{waddles}->{$waddleID}));
       my $maxClients = $self->{waddles}->{$waddleID}->{max};
       $self->{waddles}->{$waddleID} = {clients => {}, max => $maxClients};
}

method getWaddleString($waddleID) {
       return if (!exists($self->{waddles}->{$waddleID}));
       my $rtnStr = $waddleID . '|';
       for (my $count = 0; $count < ($self->{waddles}->{$waddleID}->{max} - 1); $count++) {
            if (!exists($self->{waddles}->{$waddleID}->{clients}->{$count})) {
                $rtnStr .= ',';
                next;
            }
            $rtnStr .= $self->{waddles}->{$waddleID}->{clients}->{$count}->{username} . ',';
       } 
       return $rtnStr . '%';
}

method getUpdateString($waddleID) {
      my $waddle = $self->{waddles}->{$waddleID};
      my $rtnStr = $waddle->{max} . '%';
      foreach (values %{$waddle->{clients}}) {
               $rtnStr .= $_->{username} . '|' . $_->{colour} . '|' . $_->{hand} . '|' . lc($_->{username}) . '%';
      }
      return $rtnStr;
}

method prepareWaddle($waddleID) {
       return;
}

1;
