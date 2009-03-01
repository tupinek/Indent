# Modules.
use Indent::Word;
use Test::More 'tests' => 6;

print "Testing: No-indenting data.\n";
my $obj = Indent::Word->new(
	'next_indent' => '  ',
	'line_size' => '20',
);
my $set_no_indent = 1;
my $act_indent = '---';
my $data = 'a b c d e f g h i j k l m n o p q r s t u v w x y z' x 2;
my $ret = $obj->indent($data, $act_indent, $set_no_indent);
is(length $ret, length($data) + 3);

print "Testing: Indenting data.\n";
$set_no_indent = 0;
my @ret = $obj->indent($data, $act_indent, $set_no_indent);
my $log = 0;
foreach my $line (@ret) {
	if (length $line > 20) {
		$log = 1;
	}
}
is($#ret, 6);
is($log, 0);

print "Testing: Indenting data, but data is non-indented.\n";
$data = 'abcdefghijklmnopqrstuvwxyz' x 3;
$ret = $obj->indent($data, $act_indent, $set_no_indent);
is($ret, '---abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdef'.
	'ghijklmnopqrstuvwxyz');

print "Testing: Indenting data with actual indent.\n";
$data = 'text';
$obj = Indent::Word->new(
	'next_indent' => '',
	'line_size' => '5',
);
$ret = $obj->indent($data, '<-->');
is($ret, '<-->text');

$data = 'text text';
$obj = Indent::Word->new(
	'next_indent' => ' ',
	'line_size' => '5',
);
my @right_ret = (
	'<->text',
	'<-> text',
);
@ret = $obj->indent($data, '<->');
is_deeply(\@ret, \@right_ret);