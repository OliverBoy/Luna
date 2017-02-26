package Crumbs;

use strict;
use warnings;

use Method::Signatures;
use JSON qw(decode_json);
use Cwd;

method new($resChild) {
       my $obj = bless {}, $self;
       $obj->{child} = $resChild;
       $obj->{jsons} =  {
               items => 'paper_items.json',
               igloos => 'igloos.json',
               floors => 'igloo_floors.json',
               furns => 'furniture_items.json',
               rooms => 'rooms.json',
               stamps => 'stamps.json',
               pcards => 'postcards.json'
       };  
       $obj->{methods} = {
               paper_items => 'loadItems',
               igloos => 'loadIgloos',
               igloo_floors => 'loadFloors',
               furniture_items => 'loadFurnitures',
               rooms => 'loadRooms',
               stamps => 'loadStamps',
               postcards => 'loadPostcards',
       };
       $obj->{directory} = 'file://' . cwd . '/Misc/JSON/';
       return $obj;
}

method updateCrumbs {
       my $strDir = 'Misc/JSON/';
       my @arrUrls;
       while (my ($strKey, $strFile) = each(%{$self->{jsons}})) {
              if ($strKey ne 'pcards') {
                  my $strLink = 'http://media1.clubpenguin.com/play/en/web_service/game_configs/';
                  my $strUrl = $strLink . $strFile;
                  push(@arrUrls, $strUrl);
              }
       }
       eval {
          $self->{child}->{modules}->{tools}->asyncDownload($strDir, \@arrUrls);
       };
       if ($@) {
           return $self->{child}->{modules}->{logger}->output('Failed To Update Crumbs Due To Error: ' . $@, Logger::LEVELS->{err});
       }
       $self->{child}->{modules}->{logger}->output('Successfully Updated Crumbs', Logger::LEVELS->{inf});
}

method loadCrumbs {
       my @arrFiles;
       foreach (values %{$self->{jsons}}) {
                my $strFile = $self->{directory} . $_;
                push(@arrFiles, $strFile);
       }
       my $arrInfo;
       eval {
          $arrInfo = $self->{child}->{modules}->{tools}->asyncGetContent(\@arrFiles);
       };
       if ($@) {
           return $self->{child}->{modules}->{logger}->output('Failed To Load Crumbs Due To Error: ' . $@, Logger::LEVELS->{err});
       }
       while (my ($strKey, $arrData) = each(%{$arrInfo})) {
              if (exists($self->{methods}->{$strKey})) {
                  my $strMethod = $self->{methods}->{$strKey};
                  if (defined(&{$strMethod})) {
                      $self->$strMethod(decode_json($arrData));
                  }
              }
       }
}

method loadItems($arrItems) {
       foreach (sort @{$arrItems}) {
                if ($_->{is_epf}) {
                    %{$self->{epfCrumbs}->{$_->{paper_item_id}}} = (points => $_->{cost});               
                } else {
					if ($_->{type} != 1) {
                        %{$self->{itemCrumbs}->{$_->{paper_item_id}}} = (cost => $_->{cost}, type => $_->{type}, isBait => $_->{is_bait});
                    }
                }
       }
       $self->{child}->{modules}->{logger}->output('Successfully Loaded ' . scalar(keys %{$self->{itemCrumbs}}) . ' Items', Logger::LEVELS->{inf});
       $self->{child}->{modules}->{logger}->output('Successfully Loaded ' . scalar(keys %{$self->{epfCrumbs}}) . ' EPF Items', Logger::LEVELS->{inf});
}

method loadStamps($arrStamps) {
       foreach my $arrIndexStamps (sort @{$arrStamps}) {
          foreach my $arrIndexTwoStamps (sort %{$arrIndexStamps}) {
             if (ref($arrIndexTwoStamps) eq 'ARRAY') {
                 foreach my $strStamp (sort @{$arrIndexTwoStamps}) {
                    %{$self->{stampCrumbs}->{$strStamp->{stamp_id}}} = (rank => $strStamp->{rank});
				            }	
			         }
	         }
       }
       $self->{child}->{modules}->{logger}->output('Successfully Loaded ' . scalar(keys %{$self->{stampCrumbs}}) . ' Stamps', Logger::LEVELS->{inf});
}

method loadIgloos($arrIgloos) {
       foreach (sort keys %{$arrIgloos}) {
                %{$self->{iglooCrumbs}->{$arrIgloos->{$_}->{igloo_id}}} = (cost => $arrIgloos->{$_}->{cost});    
       }
       $self->{child}->{modules}->{logger}->output('Successfully Loaded ' . scalar(keys %{$self->{iglooCrumbs}}) . ' Igloos', Logger::LEVELS->{inf});
}

method loadFloors($arrFloors) {
       foreach (sort @{$arrFloors}) {
                %{$self->{floorCrumbs}->{$_->{igloo_floor_id}}} = (cost => $_->{cost});
       }
       $self->{child}->{modules}->{logger}->output('Successfully Loaded ' . scalar(keys %{$self->{floorCrumbs}}) . ' Floors', Logger::LEVELS->{inf});
}

method loadFurnitures($arrFurns) {
       foreach (sort @{$arrFurns}) {
                %{$self->{furnitureCrumbs}->{$_->{furniture_item_id}}} = (cost => $_->{cost});
       }
       $self->{child}->{modules}->{logger}->output('Successfully Loaded ' . scalar(keys %{$self->{furnitureCrumbs}}) . ' Furnitures', Logger::LEVELS->{inf});
}

method loadRooms($arrRooms) {
       foreach (sort keys %{$arrRooms}) {
                my $intRoom = $arrRooms->{$_}->{room_id};
                my $intLimit = $arrRooms->{$_}->{max_users};
                my $strKey = $arrRooms->{$_}->{room_key};
                if ($strKey ne '') {
	                   %{$self->{roomCrumbs}->{$intRoom}} = (name => $strKey, limit => $intLimit);
                } else {
                    %{$self->{gameRoomCrumbs}->{$intRoom}} = (limit => $intLimit);
                }
       }
       $self->{child}->{modules}->{logger}->output('Successfully Loaded ' . scalar(keys %{$self->{roomCrumbs}}) . ' Rooms', Logger::LEVELS->{inf});
       $self->{child}->{modules}->{logger}->output('Successfully Loaded ' . scalar(keys %{$self->{gameRoomCrumbs}}) . ' Game Rooms', Logger::LEVELS->{inf});
}

method loadPostcards($arrPostcards) {
       while (my ($intCardID, $intCardCost) = each(%{$arrPostcards})) {
              %{$self->{mailCrumbs}->{$intCardID}}  = (cost => $intCardCost);
       }
       $self->{child}->{modules}->{logger}->output('Successfully Loaded ' . scalar(keys %{$self->{mailCrumbs}}) . ' Postcards', Logger::LEVELS->{inf});
}

1;
