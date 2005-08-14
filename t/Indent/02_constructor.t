# $Id: 02_constructor.t,v 1.5 2005-08-14 16:25:54 skim Exp $

print "Testing: new() plain constructor.\n" if $debug;
my $obj = $class->new();
ok(defined $obj, 1);
ok($obj->isa($class), 1);
ok($obj, qr/$class/);

print "Testing: new('') bad constructor.\n" if $debug;
eval {
	$obj = $class->new('');
};
ok($@, "$class: Unknown parameter ''.\n");

print "Testing: new('something' => 'value') bad constructor.\n" if $debug;
eval {
	$obj = $class->new('something' => 'value');
};
ok($@, "$class: Unknown parameter 'something'.\n");
