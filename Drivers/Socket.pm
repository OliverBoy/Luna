package Socket;

use strict;
use warnings;

use Method::Signatures;
use IO::Socket;
use IO::Select;
use Switch;

method new($resChild) {
       my $obj = bless {}, $self;
       $obj->{child} = $resChild;
       $obj->{jobStamp} = 0;
       return $obj;
}

method createSocket($intPort) {
       $self->{socket} = IO::Socket::INET->new(LocalAddr => 0, LocalPort => $intPort, Proto => 0, Listen => SOMAXCONN, ReuseAddr => 1, Blocking => 0);
       $self->{listener} = IO::Select->new($self->{socket});
}

method serverLoop {
       my @arrSocks = $self->{listener}->can_read(0);
       foreach my $resSock (@arrSocks) {
          if ($resSock == $self->{socket}) {
              $self->addClient;
              next;
          }
          eval {
             my $objClient = $self->getClientBySock($resSock);              
             my $strBuffer;
             my $intBytes = $resSock->sysread($strBuffer, 65536);
             if ($intBytes <= 0 || $strBuffer eq '') {
                 return $self->removeClient($objClient->{sock});
             }
             my @arrData = split(chr(0), $strBuffer);
             foreach (@arrData) {                         
				      $self->handleData($_, $objClient);    
             }
          };
          if ($@) {
              $self->{child}->{modules}->{logger}->output('Error: ' . $@, Logger::LEVELS->{err});
          }
      }
      $self->runCrons;
}

method runCrons {
       my $intTime = time;
       my $intStamp = $intTime + 20;
       if (!$self->{jobStamp}) {
           $self->{jobStamp} = $intStamp;
       } elsif ($intTime > $self->{jobStamp}) {
			       $self->updateServPop;
			       $self->{jobStamp} = $intStamp;
       }
}

method updateServPop {
       if ($self->{child}->{servConfig}->{servType} eq 'game') {
           my $strName = $self->{child}->{servConfig}->{servName};
           my $intPort = $self->{child}->{servConfig}->{servPort};
           my $intPop = scalar(keys %{$self->{child}->{clients}});
           $self->{child}->{modules}->{mysql}->updateTable('servers', 'curPop', $intPop, 'servPort', $intPort);
           $self->{child}->{modules}->{logger}->output('Server: ' . $strName . '|Population: ' . $intPop, Logger::LEVELS->{inf});
       }
}

method getClientBySock($resSock) {
       foreach (values %{$self->{child}->{clients}}) {
                if ($_->{sock} == $resSock) {
                    return $_;
                }
       }
       return;
}

method addClient {
       my $resSocket = $self->{socket}->accept;
       $self->{listener}->add($resSocket);
       my $objClient = CPUser->new($self->{child}, $resSocket);
       my $intKey = fileno($resSocket);
       my $strIP = $self->getClientIPAddr($resSocket);
       $self->{child}->{clients}->{$intKey} = $objClient;
       $objClient->{ipAddr} = $strIP;
      # $self->{child}->{iplog}->{$strIP} = ($self->{child}->{iplog}->{$strIP}) ? $self->{child}->{iplog}->{$strIP} + 1 : 1;
      # if (exists($self->{child}->{iplog}->{$strIP}) && $self->{child}->{iplog}->{$strIP} > 3) {
     #      return $self->removeClient($resSocket);
     #  } 
}

method handleData($strData, $objClient) {
        if ($self->{child}->{servConfig}->{debugging}) {
             $self->{child}->{modules}->{logger}->output('Packet Received: ' . $strData, Logger::LEVELS->{dbg});
        }
        my $chrType = substr($strData, 0, 1);
        switch ($chrType) {                    
        		case ('<') {
        			$self->{child}->handleXMLData($strData, $objClient);
        		}
        		case ('%') {
        			$self->{child}->handleXTData($strData, $objClient);
        		}
        		else {
        			$self->removeClient($objClient->{sock});
        		}
        }
}

method removeClient($resSocket) {
       while (my ($intIndex, $objClient) = each(%{$self->{child}->{clients}})) {
              if ($objClient->{sock} == $resSocket) {
                  $self->{listener}->remove($resSocket);
                  $resSocket->close;
                 # delete($self->{child}->{iplog}->{$objClient->{ipAddr}});
                  delete($self->{child}->{clients}->{$intIndex});
              }
       }
}

method getClientIPAddr($resSock) {
       my $strAddr = $resSock->peeraddr;
       my $strIP = inet_ntoa($strAddr);
       return $strIP;
}

1;
