#------------------------------------------------------------------------------
package Indent::Block;
#------------------------------------------------------------------------------
# $Id: Block.pm,v 1.1 2007-01-25 14:21:29 skim Exp $

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
		if (length $first >= $self->{'line_size'}
			|| length $first.$second > $self->{'line_size'}) {

			if ($first !~ /^\s+$/) {
				push @data, $first;
			}
			$first = $second;
			$second = '';
		} else {
			$first .= $second;
		}
	}

	# Add other data to @data array.
	push @data, $first if $first || $first !~ /^\s*$/;

	# Return as array or one line with output separator between its.
	return wantarray ? @data : join($self->{'output_separator'}, @data);
}

1;