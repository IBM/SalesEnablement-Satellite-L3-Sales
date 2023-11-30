#/usr/bin/perl
#
# This script requires the IBM Cloud CLI along with the following plug-ins.
# You must have administrative rights to the cloud account: ITZ-Satellite.
# This script will show you all the current users in the satellite-users accessgroup along with their IBM ID and the date they were added.
# It also lists all access groups with the "se-l3" prefix. These access groups will have the users IBM ID in it so you an match things up.

#---------------------------------------------------------------------------------------------
# functions
#---------------------------------------------------------------------------------------------
sub prompt {
  my ($query) = @_; # take a prompt string as argument
  local $| = 1; # activate autoflush to immediately show the prompt
  print $query;
  chomp(my $answer = <STDIN>);
  return $answer;
}
sub prompt_yn {
  my ($query) = @_;
  my $answer = prompt("$query (Y/N): ");
  return lc($answer) eq 'y';
}
#---------------------------------------------------------------------------------------------

$AccessGroup="satellite-users";
# $ResourceGroup="PowerVS-L3";
$AccountID="b77832f89c084e1d994ec9ae8e1bce0e";
$REGION="us-south";
$USERS_FILE="allUsers.json";


# set the target region
print "Set region to $REGION\n";
`ibmcloud target -r $REGION > /dev/null 2>&1`;

# get iam token so can query IAM
print "Retrieving OAUTH TOKEN\n";
$TOKEN=`ibmcloud iam oauth-tokens|cut -f2 -d':'`;

# get all the users in the account so we can get users added-on date
# added the '--http1.1' flag to make this work in IBM CLoud Shell

print "Retrieving all the users in the account.\n";
`curl --http1.1 -X GET   https://user-management.cloud.ibm.com/v2/accounts/$AccountID/users   -H 'Authorization: $TOKEN' > $USERS_FILE 2> /dev/null`;


# use tail -n 2 to get rid of the header
print "Retrieving all the users in the $AccessGroup access group.\n";
@users=`ibmcloud iam access-group-users $AccessGroup -q | tail -n +2`;
chomp @users;

print "The following users are actively in the $AccessGroup Access Group:\n";
# print "User ID                       IBM ID               Added On Date\n";
printf("%-35s %17s %25s\n","User ID", "IBM ID", "Added on Date");
foreach my $user (@users)
{
    # find the user in the json output  file and parse out the fields we want
    @userInfo=`jq -r '.resources[] | select(.user_id=="$user") | .iam_id,.added_on' $USERS_FILE`;
    chomp @userInfo;
    printf("%-35s %17s %25s\n",$user,@userInfo[0],@userInfo[1]);
}

## fetch access groups that have prefix "se-l3" and what users are in it

print "\nGetting access groups that start with \"se-l3\"\n\n";

@accessGroups=`ibmcloud iam ags|grep "se-l3" | cut -f1 -d' '`;
chomp(@accessGroups);
for my $ag (@accessGroups)
{
    @groupUsers=`ibmcloud iam access-group-users $ag -q`;
    chomp(@groupUsers);
 
    shift(@groupUsers); # get rid of the NAME header
    print "Access group: $ag has the following user(s):\n";
    for my $agUser (@groupUsers) 
    {
        print "$agUser\n";
    }
    print "\n";
}


print "\nExiting.\n"; 

