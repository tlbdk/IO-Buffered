package IO::Buffered::FixedSize; 
use strict;
use warnings;
use Carp;

use base ("IO::Buffered");

# FIXME: Write documentation

our $VERSION = '1.00';

=head1 NAME

IO::Buffered::FixedSize - Fixed size buffering

=head1 DESCRIPTION

=head1 SYNOPSIS

=head1 METHODS

=over

=cut

use base "Exporter";

our @EXPORT_OK = qw();

=item new()

=cut

sub new {
    my ($class, $length, %opts) = @_;
    
    # Check if $length is a number
    croak "FixedSize should be a number" if !(defined $length 
        and $length =~ /^\d+$/);

    # Check that $regexp is a Regexp or a non empty string
    croak "Option MaxSize should be a positiv integer" if $opts{MaxSize} and !( 
        $opts{MaxSize} =~ /^\d+$/ and $opts{MaxSize} > 0);

    my %self = (
        buffer => '',
        length => $length,
        maxsize => $opts{MaxSize},
    );
    
    return bless \%self, (ref $class || $class);
}


=item flush($str, ...)

=cut

sub flush {
    my $self = shift;
    $self->{buffer} = join ('', @_);
}

=item buffer()

=cut

sub buffer {
    my $self = shift;
    return $self->{buffer}; 
}

=item write($str, ...)

=cut

sub write {
    my $self = shift;
    my $str = join ('', @_);
    
    if(my $maxsize = $self->{maxsize}) {
        my $length = length($str) + length($self->{buffer});
        if($length > $maxsize) {
            croak "Buffer overrun";
        }
    }

    $self->{buffer} .= $str;
}

=item read()

=cut

sub read {
    my ($self) = (@_); 
    my $length = $self->{length};

    my @records; 
    while($length <= length($self->{buffer})) {
        push(@records, substr($self->{buffer}, 0, $length));
        substr($self->{buffer}, 0, $length, '');
    }
    return @records;
}

=item returns_last()

=cut

sub returns_last {
    return 1;
}

=item read_last()

=cut

sub read_last {
    my ($self) = @_;
    my @records = $self->read();
    push(@records, $self->{buffer}) if $self->{buffer} ne '';
    $self->{buffer} = '';
    return @records; 
}


=back

=head1 AUTHOR

Troels Liebe Bentsen <tlb@rapanden.dk> 

=head1 COPYRIGHT

Copyright(C) 2008 Troels Liebe Bentsen

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;

