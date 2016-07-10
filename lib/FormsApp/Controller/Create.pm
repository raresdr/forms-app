package FormsApp::Controller::Create;
use Moose;
use namespace::autoclean;

use FormsApp::ProcessFactory;

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

Action for form create page.

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

=head2 post_form

Creates a basic form with title and description.
Used as POST submit.

Input:  title - required
        description - required

=cut

sub post_form :Local {
    my ( $self, $c ) = @_;
    
    my $process;
    
    eval {
        $process = FormsApp::ProcessFactory
            ->create('create', { schema => $c->model('DB')->schema })
            ->create_object(
                {
                    create_with => {
                        title => $c->request->params->{title},
                        description => $c->request->params->{description}
                    },
                    obj_type => 'Form',
                    message => 'Required fields missing'
                }
            );
    };
    
    if ( $@ ) {
        $c->log->error($@);
        $c->res->redirect($c->uri_for('/error'));
        return;
    }
    
    # Required fields are missing - redirect to create page with specific messages
    if ( $process->{error} ) {
        $c->res->redirect($c->uri_for($self->action_for('index'),
            {
                error_msg => $process->{message},
                title => $c->request->params->{title},
                description => $c->request->params->{description}
            })
        );
        return;
    } else {
        # Processed successfully - redirect to edit page for this form
        $c->res->redirect($c->uri_for('/edit',($process->{object}->id)));
    }
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
