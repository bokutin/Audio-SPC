package Audio::ID666;

use strict;
use warnings;

use Audio::ID666::Binary;
use Audio::ID666::Text;

sub new {
    my ( $class, $data ) = @_;

    for (qw(Binary Text)) {
        my $format = "Audio::ID666::$_";
        $format->is_valid($data) and return $format->new($data);
    }

    die;
}

=head1 AUTHOR

Tomohiro Hosaka, C<< <bokutin at bokut.in> >>

=head1 COPYRIGHT & LICENSE

This module is free software; you can redistribute it or 
modify it under the same terms as Perl itself.

=cut

1;
