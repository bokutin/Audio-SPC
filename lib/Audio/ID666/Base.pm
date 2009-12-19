package Audio::ID666::Base;

use strict;
use warnings;

use constant {
    IDX_NAME    => 0,
    IDX_OFFSET  => 1,
    IDX_LENGTH  => 2,
    IDX_COMMENT => 3,
    IDX_FIXED   => 4,
};

sub new {
    my ( $class, $data ) = @_;

    my $self = bless {}, $class;

    die unless $self->is_valid($data);

    $self->{data} = $data;

    $self;
}

sub get_field {
    my ( $self, $name ) = @_;

    use List::Util qw(first);

    my $spec = first { $_->[IDX_NAME] eq $name } (@{$self->format}) or die;
    substr($self->{data}, hex($spec->[IDX_OFFSET]), $spec->[IDX_LENGTH]);
}

sub is_valid {
    my ( $self, $data ) = @_;

    $data ||= $self->{data};

    for (@{ $self->format }) {
        next unless $_->[IDX_NAME] eq "(未使用)";

        return 0 unless 
            substr($data, hex($_->[IDX_OFFSET]), $_->[IDX_LENGTH]) eq pack("c", hex($_->[IDX_FIXED])) x $_->[IDX_LENGTH];
    }

    return 1;
}

1;
