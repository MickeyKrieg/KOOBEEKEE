#!/usr/bin/perl -w
 
use strict;
use LWP;
use utf8;
use Perl6::Say;
use HTTP::Request::Common;
use Games::Dice 'roll';
use Data::Entropy qw(entropy_source);

# Pragma is deprecated //Non error//
#===========uncomment this string if you use windows============= 
use open ':std', ':encoding(cp866)';  # Encoding used by console
use open IO => ':encoding(cp866)';   # Encoding used by files
#===========This string end========================
# Get your token here: http://oauth.vk.com/authorize?client_id=2890984&scope=notify,friends,photos,audio,video,docs,notes,pages,status,offers,questions,wall,groups,messages,notifications,stats,ads,offline&redirect_uri=http://api.vk.com/blank.html&display=page&response_type=token 
#
# After that, get token from address,
sub get_data {
	my $url = shift;
    my $ua = LWP::UserAgent->new (agent=>'Mozilla/4.0 (compatible;)', requests_redirectable=>0);
        my $get_url = $ua->request (GET "$url") ; 
        my $res_url = $get_url->as_string();
    return ($res_url);
}

my $rand='';
my $url='';
my $dices='';
my $myid = 0;
open(TOKEN,"token.txt");
my $token = <TOKEN>;
my $conf = $ARGV[0]+ 2000000000;
say 'Hate Robot Control Center: Login...';
my $API = 'https://api.vk.com/method/';
my $test_personel = $API.'users.get?user_ids=&fields=first_name,last_name&access_token='.$token.'&version=5.92';
my $CheckIsNew = $API.'messages.getHistory?offset=0&count=1&user_id='.$conf.'&access_token='.$token.'&version=5.92';
my $screen_name = &get_data($test_personel);
my $s = $screen_name;
#say $s;
if ($s =~ /(\{\"response\"\:\[\{\"uid\"\:)(\d+)(.*)(\"\}\]\})/ )
		{
		say 'Welcome! You logged as:';
        say 'id: '.$2;
		$myid=$2;
		}
	else {
	die "Houston, we have a problem...";
	}
		
LOOP:


$s = &get_data($CheckIsNew);
if ($s=~ /\{\"response\"\:\[\d+\,\{\"body\"\:\"K|kI|iL|lL|l\"\,\".*\"from_id\"\:(\d+)\,.*/){
say $1;

$url=$API.'messages.send?chat_id='.$ARGV[0].'&message=@id'.$1.' killed dice bot &v=5.92&access_token='.$token.'&attachment=&random_id='.$rand;
$s=&get_data($url);
sleep 3;
die "Disabled by User";}
if ($s=~ /\{\"response\"\:\[\d+\,\{\"body\"\:\"roll (\d+d\d+\+*\d*)\"\,\".*\"from_id\"\:(\d+)\,.*/)
{
say $1.' '.$2;
$dices=roll $1;
$rand = entropy_source->get_int(rand(99999));
say $rand;
say $dices;
$url=$API.'messages.send?chat_id='.$ARGV[0].'&message=@id'.$2.' DICE: '.$dices.'&v=5.92&access_token='.$token.'&attachment=&random_id='.$rand;
$s=&get_data($url);
say $s;
}
if ($s=~ /\{\"response\"\:\[\d+\,\{\"body\"\:\"makeplayer (.*)\"\,\".*\"from_id\"\:(\d+)\,.*/){
$url=$API.'messages.send?chat_id='.$ARGV[0].'&message=@id'.$2.' created a charsheet  '.$1.'&v=5.92&access_token='.$token.'&attachment=&random_id='.$rand;
$s=&get_data($url);
mkdir('.\\players\\'.$1,0777);
}
if ($s=~ /\{\"response\"\:\[\d+\,\{\"body\"\:\"delplayer (.*)\"\,\".*\"from_id\"\:(\d+)\,.*/){
$url=$API.'messages.send?chat_id='.$ARGV[0].'&message=@id'.$2.' deleted a charsheet  '.$1.'&v=5.92&access_token='.$token.'&attachment=&random_id='.$rand;
$s=&get_data($url);
rmdir('.\\players\\'.$1);
}
sleep 1;
goto LOOP;