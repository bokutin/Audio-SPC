package Audio::ID666::Binary;

use strict;
use warnings;

use base "Audio::ID666::Base";

my @FORMAT = map { my @cols = m/^(.*) ([\dA-Z]{5}) (\d+) ((?:.(?!すべて))*(?: すべて (0x..))?.*)$/ or die; \@cols; } split(/\n/, <<'');
ファイル ヘッダ情報 00000 33 SNES-SPC700 Sound File Data vX.XX (v がないときもある)
(未使用) 00021 2 ヘッダとタグを分けるための未使用領域。 すべて 0x1A。
タグの種類 00023 1 タグの種類。 0x1A = ID666, 0x1B = その他。
タグのバージョン 00024 1 タグのバージョン (数値)。
SPC レジスタ (PC) 00025 2 SPC を保存した直前の SPC700 レジスタ。
SPC レジスタ (A) 00027 1 SPC を保存した直前の SPC700 レジスタ。
SPC レジスタ (X) 00028 1 SPC を保存した直前の SPC700 レジスタ。
SPC レジスタ (Y) 00029 1 SPC を保存した直前の SPC700 レジスタ。
SPC レジスタ (PSW) 0002A 1 SPC を保存した直前の SPC700 レジスタ。
SPC レジスタ (SP) 0002B 1 SPC を保存した直前の SPC700 レジスタ。
(未使用) 0002C 2 未使用領域。 すべて 0x00。
曲名 0002E 32 曲のタイトル。
ゲーム名 0004E 32 ゲームのタイトル。
作成者 0006E 16 SPC ファイルの作成者。
コメント 0007E 32 コメント。
日付 (日) 0009E 1 日付の日の部分 (数値)。 最小 1、最大 31。
日付 (月) 0009F 1 日付の月の部分 (数値)。 最小 1、最大 12。
日付 (年) 000A0 2 日付の年の部分 (数値)。 最小 1、最大 9,999。
(未使用) 000A2 7 未使用領域。 すべて 0x00。
演奏時間 000A9 2 曲の演奏時間 [秒] (数値)。 最大 999。
(未使用) 000AB 1 未使用領域。 すべて 0x00。
フェードアウト時間 000AC 3 フェードアウトの時間 [ms] (数値)。 最大 99,999。
(未使用) 000AF 1 未使用領域。 すべて 0x00。
作曲者 000B0 32 作曲者。
初期チャンネル無効 000D0 1 現在は未使用。
エミュレータの種類 000D1 1 エミュレータの種類。
(未使用) 000D2 46 未使用領域。 すべて 0x00。

sub format { \@FORMAT }

1;