package Logger;

use strict;
use warnings;

use Method::Signatures;
use feature qw(say);
use POSIX qw(strftime);

use constant LEVELS => {
    err => 'error',
    inf => 'info',
    wrn => 'warn',
    dbg => 'debug',
    ntc => 'notice'
};

method new {
       my $obj = bless {}, $self;
       return $obj;
}

method output($strMessage, $strType) {
       my $strTime = strftime('%I:%M:%S[%p]', localtime);
       say '[' . $strTime . ']' . '[' . uc($strType) . '] =>> ' . $strMessage;
       if ($strType eq 'error' || $strType eq 'warn') {
           my $strText = '<' . $strTime . '>: ' . $strMessage;
           $self->writeLog($strMessage);
       }
}

method writeLog($strText, $resFile = 'Logs.log') {
       my $resHandle;
       open($resHandle, '>>', $resFile);
       say $resHandle $strText;
       close($resHandle);
}

method kill($strMsg, $strType) {
       $self->output($strMsg, $strType);
       exit;
}

1;
