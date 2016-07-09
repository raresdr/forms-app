package FormsApp::Controller::Create;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

FormsApp::Controller::Create - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 begin

Set page title for the current controller (/)

=cut

sub begin :Private {
    my ( $self, $c ) = @_;
    
    $c->stash( page_title => 'Create Form' );
}

=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
    
    $c->stash(
        template => 'create.html',
        title => $c->request->params->{title},
        description => $c->request->params->{description},
        error_msg => $c->request->params->{error_msg}
    );
}

=head2 create

=cut

sub post_base_form :Local {
    my ( $self, $c ) = @_;

    # Retrieve the values from the form
    my $title = $c->request->params->{title};
    my $description = $c->request->params->{description};
    
    unless ( $title && $description ) {
        # Redirect to the index action/method in this controller
        $c->res->redirect($c->uri_for($self->action_for('index'),
            {
                error_msg => "Required fields missing",
                title => $title,
                description => $description
            })
        );
        return;
    }
    
    # TO DO
    # error handling
    
    # Create the form
    my $form = $c->model('DB::Form')->create({
        title   => $title,
        description  => $description,
    });
    
     $c->res->redirect($c->uri_for('/edit',($form->id)));
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
