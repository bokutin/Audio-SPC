package Audio::SPC;

use strict;
use warnings;

use constant {
    IDX_KEY     => 0,
    IDX_NAME    => 1,
    IDX_OFFSET  => 2,
    IDX_LENGTH  => 3,
    IDX_COMMENT => 4,
};

my @FORMAT = map {
    my @cols = m/^(\w+) (.*) ([\dA-Z]{5}) ([\d,]+) (.*)$/ or die $_;
    $cols[IDX_LENGTH] =~ s/,//g;
    $cols[IDX_OFFSET] = hex($cols[IDX_OFFSET]);
    \@cols;
} split(/\n/, <<'');
header SPC ファイル ヘッダ 00000 256 ID666 などの SPC ファイル情報。
ram SPC 64KB RAM 00100 65,536 64KB RAM の内容です。 サウンド ドライバやシーケンス、波形データなど。
dsp_register SPC DSP レジスタ 10100 128 DSP レジスタの内容です。 音量設定やチャンネル設定など。
unused_field (未使用) 10180 64 －
xram_buffer SPC XRAM バッファ 101C0 64 拡張 RAM の内容です。

sub new {
    my ( $class, $data ) = @_;

    my $self = bless {}, $class;

    for (@FORMAT) {
        my $key = $_->[IDX_KEY];
        my $field = substr($data, $_->[IDX_OFFSET], $_->[IDX_LENGTH]);
        $self->{$key} = $field;
    }

    $self;
}

accessor: {
    no strict 'refs';

    for (@FORMAT) {
        my $key = $_->[IDX_KEY];

        *{$key} = sub {
            my $self = shift;

            if (@_) {
                $self->{$key} = $_[0];
            }

            $self->{$key};
        };
    }
}

sub tag {
    my ( $self ) = @_;

    require Audio::ID666;
    Audio::ID666->new( $self->{header} );
}

=head1 AUTHOR

Tomohiro Hosaka, C<< <bokutin at bokut.in> >>

=head1 COPYRIGHT & LICENSE

This module is free software; you can redistribute it or 
modify it under the same terms as Perl itself.

=cut

1;
