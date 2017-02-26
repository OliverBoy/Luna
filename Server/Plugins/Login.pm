package Login;

use strict;
use warnings;

use Method::Signatures;

method new($resChild) {
       my $obj = bless {}, $self;
       $obj->{child} = $resChild;
       $obj->{pluginType} = 1;
       $obj->{property} = {
              'login' => { 
                      handler => 'handleLoginNotice',
                      isEnabled => 1
              }
       };
       return $obj;
}

method handleLoginNotice($strXML, $objClient) {
       my $username = $strXML->{body}->{login}->{nick};
       $self->{child}->{modules}->{logger}->output('Client Is Attempting To Login Using Username: ' . ucfirst($username), Logger::LEVELS->{ntc});
}

1;
