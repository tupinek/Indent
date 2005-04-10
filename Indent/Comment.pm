#------------------------------------------------------------------------------
package Indent::Comment;
#------------------------------------------------------------------------------
# $Id: Comment.pm,v 1.5 2005-04-10 12:49:10 skim Exp $

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
	
	# Comment type.
	$self->{'begin'} = '';
	$self->{'middle'} = '';
	$self->{'end'} = '';

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

	# Control.
	if (! $self->{'begin'} && ! $self->{'end'} && ! $self->{'middle'}) {
		croak "$class: Cannot define comments.";
	}

	# Comment tag is one.
	$self->{'one'} = 0;
	if (! $self->{'begin'} && ! $self->{'end'} && $self->{'middle'}) {
		$self->{'one'} = 1;
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
# @param $data Data string.

	my ($self, $data) = @_;

	# Control for data.
	if (@{$data} == -1) {
		croak "$self->{'class'}: Cannot define data.";
	}

	# Adding comments.
	my @data;
	if (! $self->{'one'}) {
		push @data, $self->{'begin'};
	}
	foreach (@{$data}) {
		push @data, $self->{'middle'}.$_;
	}
	if (! $self->{'one'}) {
		push @data, $self->{'end'};
	}

	# Return as array or one line with \n between its.
	return wantarray ? @data : join("\n", @data);
}
# END of indent().

1;