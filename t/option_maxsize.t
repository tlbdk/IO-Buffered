use strict;
use warnings;

use Test::More tests => 24;

use IO::Buffered;

my %input = (
    FixedSize => 10, 
    HTTP      => 1,
    Last      => 1,
    Regexp    => qr/(.*)\n/,
    Split     => qr/\n/, 
    Size      => ['n', 0],
);

foreach my $type (qw(FixedSize HTTP Last Regexp Size Split)) {
    $@ = undef;
    my $buffer = new IO::Buffered($type => $input{$type}, MaxSize => 100);
    ok(defined $buffer, "Could create an object");
    eval { $buffer->write("a" x 50); };
    is($@, '',  "We could add 50 bytes for $type");
    eval { $buffer->write("a" x 50); };
    is($@, '',  "We could add 50 more bytes for $type");
    eval { $buffer->write("a" x 101); };
    cmp_ok($@, "=~", qr/Buffer overrun at/, "Buffer overrun exception was thrown for $type");
}
