package CPPlugins;

use strict;
use warnings;

use Method::Signatures;

method new($resChild) {
       my $obj = bless {}, $self;
       $obj->{child} = $resChild;
       return $obj;
}

method handleXMLData($strData, $objClient) {     
       my $strXML = $self->{child}->{modules}->{tools}->parseXML($strData);
       if (!$strXML) {
           return $self->{child}->{modules}->{base}->removeClientBySock($objClient->{sock});
       }
       my $strAct = $strXML->{body}->{action};
       foreach (values %{$self->{child}->{plugins}}) {
                if ($_->{pluginType} == 1) {
                    if (exists($_->{property}->{$strAct})) {
                        if ($_->{property}->{$strAct}->{isEnabled}) {
                            my $strHandler = $_->{property}->{$strAct}->{handler};
                            if ($_->can($strHandler)) {
                                $_->$strHandler($strXML, $objClient);
                            }
                        }
                    }
                }
       }
}

method handleXTData($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $strCmd = $arrData[3];
       foreach (values %{$self->{child}->{plugins}}) {
                if ($_->{pluginType} == 2) {
                    if (exists($_->{property}->{$strCmd})) {
                        if ($_->{property}->{$strCmd}->{isEnabled}) {
                            my $strHandler = $_->{property}->{$strCmd}->{handler};
                            if ($_->can($strHandler)) {
                                $_->$strHandler($strData, $objClient);
                            }
                        }
                    }
                }
       }
}

1;
