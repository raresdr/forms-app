package FormsApp::Model::DB;

use strict;
use base 'Catalyst::Model::DBIC::Schema';

__PACKAGE__->config(
    schema_class => 'FormsApp::Schema',
    
    connect_info => {
        dsn => 'dbi:mysql:forms',
        user => 'raresd',
        password => 'yhnmju67',
        AutoCommit => q{1},
    }
);

=head1 NAME

FormsApp::Model::DB - Catalyst DBIC Schema Model

=head1 SYNOPSIS

See L<FormsApp>

=head1 DESCRIPTION

L<Catalyst::Model::DBIC::Schema> Model using schema L<FormsApp::Schema>

=head1 GENERATED BY

Catalyst::Helper::Model::DBIC::Schema - 0.65

=head1 AUTHOR

Rares Catalin Dragomir

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
