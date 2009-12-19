#!/usr/bin/env perl

# Strawberry Perl用です。
# SNESAPU.dllが必要です

use strict;
use warnings;

use IO::All;
use Win32::API;
use Win32::Sound;

my $HZ = 44100;
my $BITS = 16;
my $CH   = 2;
my $APU_CLK = 24576000;
my $DSP_TIME = 64000;

importing: {
    my $SNESAPU_HEADER = <<'';
            void ResetAPU();
            void LoadSPCFile(const void* pFile);
            void SetAPUOpt(Mixing mix, u32 chn, u32 bits, u32 rate, DSPInter inter = INT_INVALID, Set<DSPOpts> opts = ~Set<DSPOpts>());
            u32 SetDSPLength(u32 song, u32 fade);
            void* EmuAPU(void* pBuf, u32 cycles, u32 samples);

    Win32::API::Type->typedef( 'void', 'VOID' );

    local $SIG{__WARN__} = sub {};
    for (split(/\n/, $SNESAPU_HEADER)) {
        s/const//ig;
        Win32::API->Import( SNESAPU => $_ ) or die;
    }
}

sub _usage {
    my $usage = <<"USAGE";

usage:
    $0 foobar.spc

USAGE
}

main: {
    my $spc_fn = $ARGV[0] or die _usage();
    my $spc    = io->file($spc_fn)->binary->all;

    ResetAPU();
    SetAPUOpt(-1, $CH, $BITS, $HZ, -1, -1);
    LoadSPCFile($spc);
    my $play_length = SetDSPLength( $DSP_TIME*60*1, $DSP_TIME*1 );
    my $play_sec    = $play_length / $DSP_TIME;

    my $wav = Win32::Sound::WaveOut->new($HZ, $BITS, $CH);

    for (1 .. $play_sec) {
        my $buf  = " " x ($CH*$BITS*1024*8);
        my $byte = EmuAPU($buf, $APU_CLK, $HZ);
        my $pcm  = substr($buf, 0, length($buf)-length($byte));
        $wav->Load($pcm);
        $wav->Write();
    }

    Win32::Sleep(1000*1) until $wav->Status();

    $wav->Unload();
}
