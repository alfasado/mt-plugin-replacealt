package ReplaceAlt::Callbacks;

use strict;
use warnings;

sub _cb_api_post_save_entry {
    my ( $cb, $app, $obj, $original ) = @_;
    my $text = $obj->text;
    my $text_more = $obj->text_more;
    $text =~ s{
                 (
                   <img
                     (?=[^>]*?\s+alt\s*=\s*"([^"]+)")
                     (?=[^>]*?\s+src\s*=\s*"(?:[^"]*?/)?\2")
                 )
                     \s+alt\s*=\s*"[^"]+"
                 (   (?:\s[^>]*)?> \s* )
                 <p(?:\s[^>]*)?>(.+?)</p\s*>
             }{
                 my($m1, $p_html, $m3) = ($1, $4, $3);
                 $p_html =~ s/<[^>]*>//g;
                 $p_html =~ s/"/&quot;/g;
                 qq{$m1 alt="$p_html"$m3}
             }gsex;
    $text_more =~ s{
                 (
                   <img
                     (?=[^>]*?\s+alt\s*=\s*"([^"]+)")
                     (?=[^>]*?\s+src\s*=\s*"(?:[^"]*?/)?\2")
                 )
                     \s+alt\s*=\s*"[^"]+"
                 (   (?:\s[^>]*)?> \s* )
                 <p(?:\s[^>]*)?>(.+?)</p\s*>
             }{
                 my($m1, $p_html, $m3) = ($1, $4, $3);
                 $p_html =~ s/<[^>]*>//g;
                 $p_html =~ s/"/&quot;/g;
                 qq{$m1 alt="$p_html"$m3}
             }gsex;
    $obj->text( $text );
    $obj->text_more( $text_more );
    $obj->save || die $obj->errstr;
}

1;