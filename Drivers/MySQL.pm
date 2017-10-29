package MySQL;

use strict;
use warnings;

use Method::Signatures;
use DBI;

method new {
       my $obj = bless {}, $self;
       return $obj;
}

method createMysql($strHost, $strDB, $strName, $strPass) {
       $self->{connection} = DBI->connect("DBI:mysql:database=$strDB;host=$strHost", $strName, $strPass, {AutoCommit => 1, mysql_auto_reconnect => 1});
}

method updateTable($table, $set, $setValue, $where, $whereValue) {
       return if (!$table && !$set && !$setValue && !$where && !$whereValue);
       my $resQuery = $self->{connection}->prepare("UPDATE $table SET `$set` = ? WHERE `$where` = ?");
       $resQuery->execute($setValue, $whereValue);
       return $resQuery;
}

method insertData($table, \@columns, \@values) {
       return if (!$table);
       return if (!scalar(@columns));
       return if (!scalar(@values));
       my $statement = $self->{connection}->prepare("INSERT INTO $table (" . join(',', @columns) . ") VALUES (" . join(',', ('?') x @columns). ")");
       $statement->execute(@values);
       return $statement->{mysql_insertid};
}

method deleteData($table, $where, $whereValue, $andClause = 0, $andKey = '', $andValue = '') {
       return if (!$table);
       return if (!$where);
       return if (!$whereValue);
       return $andClause ? $self->deleteWithAnd($table, $where, $whereValue, $andKey, $andValue) : $self->deleteWithoutAnd($table, $where, $whereValue);
}

method deleteWithAnd($table, $whereKey, $whereValue, $andKey, $andValue) {
		my $resQuery = $self->{connection}->prepare("DELETE FROM $table WHERE `$whereKey` = ? AND $andKey = ?");
		$resQuery->execute($whereValue, $andValue);
}

method deleteWithoutAnd($table, $whereKey, $whereValue) {
		my $resQuery = $self->{connection}->prepare("DELETE FROM $table WHERE `$whereKey` = ?");
		$resQuery->execute($whereValue);
}

### NEW FUNCTIONS TO PREVENT SQL INJECTIONS ###

method serverExists($intPort) {
		my $resQuery = $self->{connection}->prepare("SELECT `servPort` FROM servers WHERE `servPort` = ?");
		$resQuery->execute($intPort);
		my $arrResult = $resQuery->fetchall_arrayref(0);
		my $blnExist = scalar(@{$arrResult});
		return $blnExist;
}

method usernameExists($strName) {
		my $resQuery = $self->{connection}->prepare("SELECT `username` FROM users WHERE `username` = ?");
		$resQuery->execute($strName);
		my $arrResult = $resQuery->fetchall_arrayref(0);
		my $blnExist = scalar(@{$arrResult});
		return $blnExist;
}

method userExistsByID($intID) {
		my $resQuery = $self->{connection}->prepare("SELECT * FROM users WHERE `ID` = ?");
		$resQuery->execute($intID);
		my $arrResult = $resQuery->fetchall_arrayref(0);
		my $blnExist = scalar(@{$arrResult});
		return $blnExist;
}

method getDetailsByUsername($strName) {
		my $resQuery = $self->{connection}->prepare("SELECT * FROM users WHERE `username` = ?");
		$resQuery->execute($strName);
		my $arrResult = $resQuery->fetchrow_hashref;
		if ($arrResult) {
		   return $arrResult;
		}
}

method getDetailsByID($intID) {
		my $resQuery = $self->{connection}->prepare("SELECT * FROM users WHERE `ID` = ?");
		$resQuery->execute($intID);
		my $arrResult = $resQuery->fetchrow_hashref;
		if ($arrResult) {
		   return $arrResult;
		}
}

method getPuffleByOwner($intPuffID, $intOwnerID) {
		my $resQuery = $self->{connection}->prepare("SELECT * FROM puffles WHERE `puffleID` = ? AND `ownerID` = ?");
		$resQuery->execute($intPuffID, $intOwnerID);
		my $arrResult = $resQuery->fetchrow_hashref;
		if ($arrResult) {
		   return $arrResult;
		}
}

method getLoginDetailsByID($intID) {
		my $resQuery = $self->{connection}->prepare("SELECT `loginKey`, `invalidLogins` FROM users WHERE `ID` = ?");
		$resQuery->execute($intID);
		my $arrResult = $resQuery->fetchrow_hashref;
		if ($arrResult) {
		   return $arrResult;
		}
}

method getStampsByID($intID) {
		my $resQuery = $self->{connection}->prepare("SELECT `stamps` FROM users WHERE `ID` = ?");
		$resQuery->execute($intID);
		my $arrResult = $resQuery->fetchrow_hashref;
		if ($arrResult) {
		   return $arrResult->{stamps};
		}
}

method getStampbookCoverByID($intID) {
		my $resQuery = $self->{connection}->prepare("SELECT `cover` FROM users WHERE `ID` = ?");
		$resQuery->execute($intID);
		my $arrResult = $resQuery->fetchrow_hashref;
		if ($arrResult) {
		   return $arrResult->{cover};
		}
}

method getRestampsByID($intID) {
		my $resQuery = $self->{connection}->prepare("SELECT `restamps` FROM users WHERE `ID` = ?");
		$resQuery->execute($intID);
		my $arrResult = $resQuery->fetchrow_hashref;
		if ($arrResult) {
		   return $arrResult->{restamps};
		}
}

method getExistingNames($strNickname) {
		my $resQuery = $self->{connection}->prepare("SELECT `username`, `nickname` FROM users WHERE `nickname` = ?");
		$resQuery->execute($strNickname);
		my $arrResult = $resQuery->fetchrow_hashref;
		if ($arrResult) {
		   return $arrResult;
		}
}

method getIglooDetailsByID($intID) {
		my $resQuery = $self->{connection}->prepare("SELECT * FROM igloos WHERE `ID` = ?");
		$resQuery->execute($intID);
		my $arrResult = $resQuery->fetchrow_hashref;
		if ($arrResult) {
		   return $arrResult;
		}
}

method getInventoryByID($intID) {
		my $resQuery = $self->{connection}->prepare("SELECT `inventory` FROM users WHERE `ID` = ?");
		$resQuery->execute($intID);
		my $arrResult = $resQuery->fetchrow_hashref;
		if ($arrResult) {
		   return $arrResult;
		}
}

method getCloneableByUsername($strName) {
		my $resQuery = $self->{connection}->prepare("SELECT `isCloneable` FROM users WHERE `username` = ?");
		$resQuery->execute($strName);
		my $arrResult = $resQuery->fetchrow_hashref;
		if ($arrResult) {
		   return $arrResult->{isCloneable};
		}
}

method getWalkingPuffle($intID) {
       my $resQuery = $self->{connection}->prepare("SELECT * FROM puffles WHERE `ownerID` = ? AND `puffleWalking` = ?");
       $resQuery->execute($intID, 1);
       my $arrResult = $resQuery->fetchrow_hashref;
       if ($arrResult) {
           return $arrResult;
       }
}

method getPufflesByOwner($intID) {
       my $resQuery = $self->{connection}->prepare("SELECT * FROM puffles WHERE `ownerID` = ?");
       $resQuery->execute($intID);
       my $arrResult = $resQuery->fetchall_arrayref({});
       if ($arrResult) {
           return $arrResult;
       }
}

method getServerDetailsByType($strType) {
       my $resQuery = $self->{connection}->prepare("SELECT * FROM servers WHERE `servType` = ?");
       $resQuery->execute($strType);
       my $arrResult = $resQuery->fetchall_arrayref({});
       if ($arrResult) {
           return $arrResult;
       }
}

method getPostcardsByID($intID) {
       my $resQuery = $self->{connection}->prepare("SELECT * FROM postcards WHERE `recepient` = ?");
       $resQuery->execute($intID);
       my $arrResult = $resQuery->fetchall_arrayref({});
       if ($arrResult) {
           return $arrResult;
       }
}

method updatePuffleStats($intHealth, $intHunger, $intRest, $intPuffle, $intOwnerID) {
		my $resQuery = $self->{connection}->prepare("UPDATE puffles SET `puffleHealth` = ?, `puffleEnergy` = ?, `puffleRest` = ? WHERE `puffleID` = ? AND `ownerID` = ?");
		$resQuery->execute($intHealth, $intHunger, $intRest, $intPuffle, $intOwnerID);
}

method getLastLoginByID($intID) {
       my $resQuery = $self->{connection}->prepare("SELECT UNIX_TIMESTAMP(LastLogin) FROM users WHERE `ID` = ?");
       $resQuery->execute($intID);
       my $arrResult = $resQuery->fetchrow_hashref;
       if ($arrResult) {
           return $arrResult->{'UNIX_TIMESTAMP(LastLogin)'};
       }
}

method updatePuffleStatByType($strType, $intStat, $intPuffle, $intOwnerID) {
		my $resQuery = $self->{connection}->prepare("UPDATE puffles SET `$strType` = ? WHERE `puffleID` = ? AND `ownerID` = ?");
		$resQuery->execute($intStat, $intPuffle, $intOwnerID);
}

method getPuffleStatByType($strType, $intPuffle, $intOwnerID) {
       my $resQuery = $self->{connection}->prepare("SELECT $strType FROM puffles WHERE `puffleID` = ? AND `ownerID` = ?");
       $resQuery->execute($intPuffle, $intOwnerID);
       my $arrResult = $resQuery->fetchrow_hashref;
       if ($arrResult) {
           return $arrResult;
       }
}

method getReceivedPostcards($intID) {
		my $resQuery = $self->{connection}->prepare("SELECT `recepient` FROM postcards WHERE `recepient` = ?");
		$resQuery->execute($intID);
		my $arrResult = $resQuery->fetchall_arrayref(0);
		my $intReceived = scalar(@{$arrResult});
		return $intReceived;
}

method getIgnoredPostcards($intID) {
		my $resQuery = $self->{connection}->prepare("SELECT `isRead` FROM postcards WHERE `recepient` = ? AND `isRead` = ?");
		$resQuery->execute($intID, 0);
		my $arrResult = $resQuery->fetchall_arrayref(0);
		my $intUnread = scalar(@{$arrResult});
		return $intUnread;
}

method updateWalkingPuffle($blnWalking, $intPuffle, $intOwner) {
		my $resQuery = $self->{connection}->prepare("UPDATE puffles SET `puffleWalking` = ? WHERE `puffleID` = ? AND `ownerID` = ?");
		$resQuery->execute($blnWalking, $intPuffle, $intOwner);
}

# // ADD FOR IGLOO PARTYS - REMOVE THE HASHTAGS

# method checkJoinedIglooContest($intID) {
# 		my $resQuery = $self->{connection}->prepare("SELECT * FROM igloo_contest WHERE `ID` = ?");
# 		$resQuery->execute($intID);
# 		my $arrResult = $resQuery->fetchall_arrayref({});
# 		if ($arrResult) {
# 		   return $arrResult;
# 		}
# }

method getLastDonations($intID) {
		my $resQuery = $self->{connection}->prepare("SELECT * FROM donations WHERE `ID` = ?");
		$resQuery->execute($intID);
		my $arrResult = $resQuery->fetchall_arrayref({});
		if ($arrResult) {
		   return $arrResult;
		}
}

1;
