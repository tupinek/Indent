#------------------------------------------------------------------------------
package Indent::Tag;
#------------------------------------------------------------------------------
# $Id: Tag.pm,v 1.3 2005-04-10 13:14:56 skim Exp $

# Modules.
use Carp;

# Version.
our $VERSION = '0.1';

#------------------------------------------------------------------------------
sub new {
#------------------------------------------------------------------------------
# Constructor.
	
	my $class = shift;
	my $self = {};
	
	# Default values.
	$self->{'indent_len'} = 79;
	$self->{'indenter'} = "\t";

	# Output.
	$self->{'output_separator'} = "\n";

	# Process params.
	croak "$class: Created with odd number of parameters - should be ".
		"of the form option => value." if (@_ % 2);
	for (my $x = 0; $x <= $#_; $x += 2) {
		if (exists $self->{$_[$x]}) {
			$self->{$_[$x]} = $_[$x+1];
		} else {
			croak "$class: Bad parameter '$_[$x]'.";
		}
	}

	# Class.
	$self->{'class'} = $class;

	# Object.
	return bless $self, $class;
}
# END of new().

#------------------------------------------------------------------------------
sub indent {
#------------------------------------------------------------------------------
# Parses tag to indented data.
# @param $self Class object.
# @param $tag Tag string.
# @param $indent String to actual indent.
# @param $non_indent Flag, than says no-indent.

	my ($self, $tag, $indent, $non_indent) = @_;

	# Undef indent.
	if (! $indent) {
		$indent = '';
	}

        # If non_indent data, than return.
	return $tag if $non_indent;

	my ($first, $second) = (undef, $indent.$tag);
	my $last_second_length = 0;
	my @data;
	my $one = 1;
	while (length $second >= $self->{'indent_len'}
		&& $second =~ /^\s*\S+\s+/
		&& $last_second_length != length $second) {

		# Last length of non-parsed part of tag.
		$last_second_length = length $second;

		# Parse to indent length.
		($first, my $tmp) = $second 
			=~ /^(.{0,$self->{'indent_len'}})\s+(.*\/?>)$/;

		# If string is non-breakable in indent length, than parse to
		# blank char.
		if (! $first || length $first < length $indent
			|| $first =~ /^$indent\s*$/) {
			($first, $tmp) = $second 
				=~ /^($indent\s*[^\s]+?)\s(.*\/?>)$/;
		}

		# If parsing is right.
		if ($tmp) {

			# Non-parsed part of tag.
			$second = $tmp;

			# Add indenter to string. 
			$indent .= $self->{'indenter'} if $one == 1;
			$one = 0;
			$second = $indent.$second;

			# Parsed part of tag to @data array.
			push @data, $first;
		}
	}

	# Add other data to @data array.
	push @data, $second;

	# Return as array or one line with \n between its.
	return wantarray ? @data : join($self->{'output_separator'}, @data);
}
# END of indent().

1;
