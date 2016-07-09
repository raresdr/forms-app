package FormsApp::View::Mason;

use strict;
use warnings;

use parent 'Catalyst::View::Mason';

__PACKAGE__->config(
    use_match => 0,
    comp_root => FormsApp->path_to(qw/root templates/)
);

=head1 NAME

FormsApp::View::Mason - Mason View Component for FormsApp

=head1 DESCRIPTION

Mason View Component for FormsApp

=head1 SEE ALSO

L<FormsApp>, L<HTML::Mason>

=head1 AUTHOR

Rares Catalin Dragomir

=head1 LICENSE

This library is free software . You can redistribute it and/or modify it under
the same terms as perl itself.

=cut

1;
