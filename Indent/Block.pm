#------------------------------------------------------------------------------
package Indent::Block;
#------------------------------------------------------------------------------

# Pragmas.
use strict;
use warnings;

# Modules.
use Error::Simple::Multiple qw(err);
use Indent::Utils qw(string_len);

# Version.
our $VERSION = 0.01;

#------------------------------------------------------------------------------
sub new {
#------------------------------------------------------------------------------
# Constructor.

	my $class = shift;
	my $self = bless {}, $class;

	# Options.
	$self->{'line_size'} = 79;
	$self->{'next_indent'} = "\t";

	# Output.
	$self->{'output_separator'} = "\n";

	# Strict mode - without white space optimalization.
	$self->{'strict'} = 1;

	# Process params.
	while (@_) {
		my $key = shift;
		my $val = shift;
		err "Unknown parameter '$key'." unless exists $self->{$key};
		$self->{$key} = $val;
	}

	# Line_size check.
	if ($self->{'line_size'} !~ /^\d*$/) {
		err "Bad line_size = '$self->{'line_size'}'.";
	}

	# Save current piece.
	$self->{'_current'} = '';

	# Object.
	return $self;
}

#------------------------------------------------------------------------------
sub indent {
#------------------------------------------------------------------------------
# Parses tag to indented data.
# @param $data Reference to data array.
# @param $act_indent String to actual indent.
# @param $non_indent Flag, that says no-indent.

	my ($self, $data, $act_indent, $non_indent) = @_;

	# Undef indent.
	if (! $act_indent) {
		$act_indent = '';
	}

	# Input data.
	my @input = @{$data};

	# If non_indent data, than return.
	return $act_indent.join('', @input) if $non_indent;

	# Indent.
	my @data = ();
	my ($first, $second);
	$first = shift @input;
	my $tmp_indent = $act_indent;
	while (@input) {
		$second = shift @input;
		if ($self->_compare($first, $second, $tmp_indent)) {
			push @data, $self->{'_current'};
			$first = $second;
			$second = '';
			$tmp_indent = $act_indent.$self->{'next_indent'};
		} else {
			$first .= $second;
		}
	}

	# Add other data to @data array.
	if ($first) {

		# White space optimalization.
		if (! $self->{'strict'}) {
			$first =~ s/^\s*//;
			$first =~ s/\s*$//;
		}
		if ($first ne '') {
			push @data, $tmp_indent.$first;
		}
	}

	# Return as array or one line with output separator between its.
	return wantarray ? @data : join($self->{'output_separator'}, @data);
}

#------------------------------------------------------------------------------
# Private methods.
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
sub _compare {
#------------------------------------------------------------------------------
# Compare strings with 'line_size' and save right current string.

	my ($self, $first, $second, $act_indent) = @_;

	# Whitout optimalization.
	if ($self->{'strict'}) {
		if (length $first > 0 
			&& (string_len($act_indent.$first) 
			>= $self->{'line_size'}
			|| string_len($act_indent.$first.$second) 
			> $self->{'line_size'})) {

			$self->{'_current'} = $act_indent.$first;
			return 1;
		} else {
			return 0;
		}
	} else {
		my $tmp1 = $first;
		$tmp1 =~ s/^\s*//;
		$tmp1 =~ s/\s*$//;
		if (length $tmp1 > 0 
			&& string_len($act_indent.$tmp1) 
			>= $self->{'line_size'}) {

			$self->{'_current'} = $act_indent.$tmp1;
			return 1;
		} else {
			my $tmp2 = $first.$second;
			$tmp2 =~ s/^\s*//;
			$tmp2 =~ s/\s*$//;
			if (length $tmp1 > 0 
				&& string_len($act_indent.$tmp2) 
				> $self->{'line_size'}) {

				$self->{'_current'} = $act_indent.$tmp1;
				return 1;
			} else {
				return 0;
			}
		}
	}
}

1;

=pod

=head1 NAME

 Indent::Block - Class for block indent.

=head1 SYNOPSIS

 use Indent::Block;
 my $i = Indent::Block->new(%parameters);
 print $i->indent($data, [$act_indent, $non_indent]);

=head1 METHODS

=over 8

=item B<new(%parameters)>

 Constructor.

=over 8

=item * B<line_size>

 Sets indent line size value.
 Default value is 'line_size' => 79.

=item * B<next_indent>

 Sets next indent string.
 Default value is 'next_indent' => "\t" (tabelator).

=item * B<output_separator>

 Sets output separator between indented datas for string context.
 Default value is 'output_separator' => "\n" (new line).

=item * B<strict>

 Sets or unsets strict mode. 
 Unset strict mode means whitespace optimalization.
 Default value is 'strict' => 1.

=back

=item B<indent($data, [$act_indent, $non_indent])>

 Indent method.
 - $data - Reference to array with strings to indent.
 - $act_indent - String to actual indent.
 - $non_indent - Flag, that says 'no-indent' for current time.

=back

=head1 EXAMPLE

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use Indent::Block;

 # Object.
 my $i = Indent::Block->new(
         'line_size' => 2,
	 'next_indent' => '',
 );
 
 # Print in scalar context.
 print $i->indent(['text', 'text', 'text'])."\n";

 # Output:
 # text
 # text
 # text

=head1 REQUIREMENTS

L<Error::Simple::Multiple(3pm)>,
L<Indent::Utils(3pm)>.

=head1 SEE ALSO

L<Indent(3pm)>,
L<Indent::Comment(3pm)>,
L<Indent::Data(3pm)>,
L<Indent::Form(3pm)>,
L<Indent::PerlStruct(3pm)>,
L<Indent::Tag(3pm)>,
L<Indent::Utils(3pm)>,
L<Indent::Word(3pm)>.

=head1 AUTHOR

 Michal Špaček F<tupinek@gmail.com>

=head1 VERSION

 0.01

=cut
