# $Id: 21-option-callback.t,v 1.1 2005/10/24 16:42:31 mike Exp $

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl 21-option-calback.t'

use strict;
use warnings;
use Test::More tests => 19;
BEGIN { use_ok('ZOOM') };

# This callback function provides values only options whose names
# begin with consonants, in which case the value is the option name
# concatenated with a hyphen and the value of the user-data that was
# lodged along with the callback.
#
sub f_option {
    my($udata, $name) = @_;

    return undef if $name =~ /^[aeiou]/;
    return "$name-$udata";
}

my $o1 = new ZOOM::Options();
$o1->set_callback("main::f_option", "xyz");
$o1->option(isisaurus => "was titanosaurus");

check($o1, "apatosaurus", undef);
check($o1, "brachiosaurus", "brachiosaurus-xyz");
check($o1, "camarasaurus", "camarasaurus-xyz");
check($o1, "diplodocus", "diplodocus-xyz");
check($o1, "euhelopus", undef);
check($o1, "futalognkosaurus", "futalognkosaurus-xyz");
check($o1, "gigantosaurus", "gigantosaurus-xyz");
check($o1, "haplocanthosaurus", "haplocanthosaurus-xyz");
check($o1, "isisaurus", "was titanosaurus");
check($o1, "janenschia", "janenschia-xyz");

my $o2 = new ZOOM::Options();
$o2->set_callback("main::f_option", "abc");
check($o2, "apatosaurus", undef);
check($o2, "brachiosaurus", "brachiosaurus-abc");
check($o2, "kxxxxxxxxxxxxx", "kxxxxxxxxxxxxx-abc");
check($o2, "limaysaurus", "limaysaurus-abc");
check($o2, "mamenchisaurus", "mamenchisaurus-abc");
check($o2, "nurosaurus", "nurosaurus-abc");
check($o2, "omeisaurus", undef);
check($o2, "patagosaurus", "patagosaurus-abc");

sub check {
    my($opts, $key, $expected) = @_;

    my $val = $opts->option($key);
    #print "$opts($key) ", (defined $val ? "= '$val'" : "undefined"), "\n";
    if (defined $expected) {
	ok ($val eq $expected, "value for '$key' is '$val'");
    } else {
	ok (!defined $val, "no value for '$key'");
    }
}
