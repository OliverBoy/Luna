package Commands;

use strict;
use warnings;

use Method::Signatures;

method new($resChild) {
       my $obj = bless {}, $self;
       $obj->{child} = $resChild;
       $obj->{pluginType} = 2;
       $obj->{property} = {
              'm#sm' => {
                     handler => 'handleCommand',
                     isEnabled => 1
              }
       };
       $obj->{commands} = {
                 members => {
                         ai => 'handleAddItem',
                         ac => 'handleAddCoins',
                         af => 'handleAddFurniture',
                         aig => 'handleAddIgloo',
                         cif => 'handleChangeIglooFloor',
                         cnick => 'handleChangeNickname',
                         ping => 'handleSendPong',
                         stats => 'handleGetStats',
                         jr => 'handleJoinRoom',
                         ng => 'handleSetNameGlow',
                         nc => 'handleSetNameColour',
                         bc => 'handleSetBubbleColour',   
                         rc => 'handleSetRingColour',
                         pg => 'handleSetPenguinGlow',
                         pc => 'handleSetPenguinColor',
                         bg => 'handleSetBubbleGlow',
                         cmg => 'handleSetMoodGlow',
                         cmc => 'handleSetMoodColor',
                         sg => 'handleSetSnowballGlow',
                         clone => 'handleClonePenguin',
                         dec => 'handleDisableEnableCloning',
                         goto => 'handleTeleportClient',
                         find => 'handleFindClient',
                         ss => 'handlePenguinSuperSize',
                         cpc => 'handleClearPenguinClothing',
                         aai => 'handleAddAllItems',
                         wow => 'handleWalkOnWalls',
                         hue => 'handleSetPlayercardHue',
                         pr => 'handleSetPenguinRotation'
                 },
                 staff => {
                       tban => 'handleTimeBanClient',
                       kbc => 'handleKickBanClient',
                       ban => 'handleBanClient',
                       kick => 'handleKickClient',
                       unban => 'handleUnbanClient',
                       shutdown => 'handleShutdownServer',
                       global => 'handleServerSayAll',
                       summon => 'handleSummonClient',
                       summonall => 'handleSummonAllClients'                
                 }
       };
       return $obj;
}

method handleCommand($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $strMsg = $arrData[6];
       my $chrCmd = substr($strMsg, 0, 1);
       my $blnMember = $chrCmd eq $self->{child}->{servConfig}->{userPrefix} ? 1 : 0;
       my $blnStaff = $chrCmd eq $self->{child}->{servConfig}->{staffPrefix} ? 1 : 0;
       return if (!$blnMember && !$blnStaff);
       $blnMember ? $self->handleCommands($strMsg, $objClient) : $self->handleStaffCommands($strMsg, $objClient);
}

method handleCommands($strMsg, $objClient) {
       my @arrParts = split(' ', substr($strMsg, 1), 2);
       my $strCmd = lc($arrParts[0]);
       my $strArg = $arrParts[1];
       return if (!exists($self->{commands}->{members}->{$strCmd}));
       my $strHandler = $self->{commands}->{members}->{$strCmd};
       $self->{child}->{modules}->{commands}->$strHandler($objClient, $strArg);
}

method handleStaffCommands($strMsg, $objClient) {
       my @arrParts = split(' ', substr($strMsg, 1), 2);
       my $strCmd = lc($arrParts[0]);
       my $strArg = $arrParts[1];
       return if (!exists($self->{commands}->{staff}->{$strCmd}));
       my $strHandler = $self->{commands}->{staff}->{$strCmd};
       if ($objClient->{isStaff}) {
           $self->{child}->{modules}->{commands}->$strHandler($objClient, $strArg);
       }
}

1;
