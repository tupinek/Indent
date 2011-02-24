# Modules.
use Indent::Utils qw(remove_ws);
use Test::More 'tests' => 6;

print "Testing: remove_ws() function.\n";
my $string = 'string   ';
remove_ws(\$string);
is($string, 'string');

$string = "string \t \t";
remove_ws(\$string);
is($string, 'string');

$string = '   string';
remove_ws(\$string);
is($string, 'string');

$string = "\t \t string";
remove_ws(\$string);
is($string, 'string');

$string = "  string \t \t";
remove_ws(\$string);
is($string, 'string');

$string = " \t \t string \t \t";
remove_ws(\$string);
is($string, 'string');