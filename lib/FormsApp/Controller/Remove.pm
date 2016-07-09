package FormsApp::Controller::Remove;
use Moose;
use namespace::autoclean;

use JSON;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

FormsApp::Controller::Remove - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    my $id = $c->request->params->{id};
    
    unless ( $id ) {
        $c->res->body( 'error - id specified');
        return;
    }
    
    # Remove option
    my $form = $c->model('DB::Form')->find({ id => $id });
    $form->delete;
    
    $c->res->body(to_json({
        success => 1,
        message => "Form with id $id deleted"
    }));
}



=encoding utf8

=head1 AUTHOR

Rares Catalin Dragomir

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
