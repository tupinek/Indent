# Pragmas.
use strict;
use warnings;

# Modules.
use Indent::PerlStruct;
use Test::More 'tests' => 1;

my $obj = Indent::PerlStruct->new;
my $struct = {
	'1' => '5',
	'2' => 5,
	'3' => '05',
	'4' => 05,
	'5' => '0.5',
	'6' => 0.5,
	'7' => 0,
	'8' => '0',
};
my $ret = $obj->indent($struct);
my $right_ret = <<"END";
{
	'1' => 5,
	'2' => 5,
	'3' => '05',
	'4' => 5,
	'5' => 0.5,
	'6' => 0.5,
	'7' => 0,
	'8' => 0,
},
END
is($ret, $right_ret);
