package Text::Rhymes;
use Text::Soundex;
our $VERSION = 0.01;
use strict;
use warnings;

=head1 NAME

Text::Rhyme - very basic test for rhymes across two words.

=head1 SYNOPSIS

	use Text::Rhyme;

	my @words = (
		'stocks','box', 'commotion','dennotion',
		'spoke','spake', 'foo','bar'
	);

	for (my $i=0; $i<=$#words; $i+=2) {
		my $rhyme_val = Text::Rhyme::test($words[$i],$words[$i+1]);
		print "$words[$i] and $words[$i+1] = $rhyme_val - ";
		if ($rhyme_val == 0) { print "as good as it gets, I'm afraid." }
		elsif ($rhyme_val<3) { print "well...not good...." }
		else { print "terrible!" }
		print "\n";
	}


=head1 DESCRIPTION

Mike Stok, who implemented perl's I<Text::Soundex> writes in that modules POD:

    As [I<Text::Soundex>] is mapping a large space (arbitrary length strings) onto a small
    space (single letter plus 3 digits) no inference can be made about the
    similarity of two strings which end up with the same soundex code. ...

It would seem that the smaller the space mapped, the greater the chance of the soundex code output reflecting the input string. This module therefore considers only a small part of a word when attempting to find a rhyme.

Common endings that produce glib rhymes ('~tion') are cut if shared by both words.

Only the final groups of vowels (preceding trailing consonants) are considered.

Each is passed to the I<Text::Soundex> routine, which returns a code of one letter and three digits.

The module returns the difference between the soundex values of the extracted vowels, as a positive integer.

=head1 LIMITATIONS

They're huge, I'm afraid: when tested, 'spoke' and 'spake' return 0, which is plainly wrong.

Any thoughts/suggestions/mods much appreciated.

=head1 EXPANSION

Any thoughts/suggestions/mods much appreciated.

Word stress patterns could help to produce a better analysis, but we need a means of identifying syllables, and sadly I<Text::Syllable> isn't up to it at the date of writing.

Any thoughts/suggestions/mods much appreciated....

=cut

#
# Suffixes to cut when shared by both words being tested.
#
our @suffixes = ('tion','ism','ing','ogy');

sub test { @_ = @_;
	my @v;		# Vowel values
	my @cut; 	# Add 1 everytime something is cut

	foreach (@suffixes){
		s/$_$//i if $_[0] =~ m/$_$/i and $_[1] =~ m/$_$/i;
	}

	for my $i (0..1){
		$_[$i] = lc $_[$i];
		my ($c,$v,$e) = ($_[$i] =~ m/([^aeiou]*)([aeiou]*)([^aeiou]*)$/);
		$c = soundex($c);
		$v = soundex($v);
		$e = soundex($e);
#		warn "$_[$i] ... C: $c    V: $v    E: $e\n";
		$v =~ m/^(\w)(\d{3})$/ or warn "Unexpected soundex value for '$v'." and return undef;
		$v[$i] = $2 + ((ord $1)-96);
	}
	return +($v[0] - $v[1]);

}

=head1 SEE ALSO

	L<Text::Soundex>

=head1 AUTHOR

Lee Goddard <lgoddard@cpan.org>

=head1 COPYRIGHT

Copyright (C) Lee Goddard, 2001.  All Rights Reserved.

This is free software which you may use under the same terms as Perl itself.
