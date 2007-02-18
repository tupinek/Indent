#------------------------------------------------------------------------------
package Indent::Block;
#------------------------------------------------------------------------------
# $Id: Block.pm,v 1.7 2007-02-18 22:47:13 skim Exp $

# Pragmas.
use strict;

# Modules.
use Error::Simple::Multiple qw(err);

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
# @param $indent String to actual indent.
# @param $non_indent Flag, than says no-indent.

	my ($self, $data, $indent, $non_indent) = @_;

	# Undef indent.
	if (! $indent) {
		$indent = '';
	}

	# If non_indent data, than return.
	return $indent.join('', @{$data}) if $non_indent;

	# Indent.
	my @data = ();
	my ($first, $second);
	$first = shift @{$data};
	$first = $indent.$first;
	while (@{$data}) {
		$second = shift @{$data};
		if ($self->_compare($first, $second)) {
			push @data, $self->{'_current'};
			$first = $second;
			$second = '';
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
			push @data, $first;
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

	my ($self, $first, $second) = @_;

	# Whitout optimalization.
	if ($self->{'strict'}) {
		if (length $first >= $self->{'line_size'}
			|| length $first.$second > $self->{'line_size'}) {

			$self->{'_current'} = $first;	
			return 1;
		} else {
			return 0;
		}
	} else {
		my $tmp1 = $first;
		$tmp1 =~ s/^\s*//;
		$tmp1 =~ s/\s*$//;
		if (length $tmp1 >= $self->{'line_size'}) {
			$self->{'_current'} = $tmp1;
			return 1;
		} else {
			my $tmp2 = $first.$second;
			$tmp2 =~ s/^\s*//;
			$tmp2 =~ s/\s*$//;
			if (length $tmp2 > $self->{'line_size'}) {
				$self->{'_current'} = $tmp1;
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

 TODO

=head1 METHODS

=over 8

=item B<new(%parameters)>

 TODO

=head1 PARAMETERS

=over 8

=item B<line_size>

TODO

=item B<next_indent>

TODO

=item B<output_separator>

TODO

=item B<strict>

TODO

=back

=item B<indent()>

 TODO

=back

=head1 EXAMPLE

 TODO

=head1 REQUIREMENTS

 L<Error::Simple::Multiple(3)>

=head1 AUTHOR

 Michal Spacek F<tupinek@gmail.com>

=head1 VERSION

 0.01

=cut
