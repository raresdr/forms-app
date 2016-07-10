package FormsApp::Controller::Submission;
use Moose;
use namespace::autoclean;

use FormsApp::ProcessFactory;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

FormsApp::Controller::Complete - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 begin

Set page title for the current controller (/)

=cut

sub begin :Private {
    my ( $self, $c ) = @_;
    
    $c->stash( page_title => 'Submit Form' );
}

=head2 index

Displays form submission page for a specific form id.

Input: form id - required

=cut

sub index :Path('complete') :Args(1) {
    my ( $self, $c, $id ) = @_;
    
    my $process;
    
    eval {
        $process = FormsApp::ProcessFactory
            ->create('read', { schema => $c->model('DB')->schema })
            ->retrieve_objects(
                {
                    search_by => { id => $id },
                    obj_type => 'Form'
                }
            );
    };
    
    if ( $@ ) {
        $c->log->error($@);
        $c->res->redirect($c->uri_for('/error'));
        return;
    }
    
    unless ( $process->{objects} && scalar @{$process->{objects}} ) {
        # Redirect to home screen  in case form does not exist
        $c->res->redirect($c->uri_for('/'));
        
        return;
    }
    
    $c->stash(
        template => 'submission/form.html',
        form => $process->{objects}->[0]
    );
}

=head2 view

Displays form response page for a specific submitted form.

Input: submission id - required

=cut

sub view :Local :Args(1) {
    my ( $self, $c, $id ) = @_;
    
    my $process;
    
    eval {
        $process = FormsApp::ProcessFactory
            ->create('read', { schema => $c->model('DB')->schema })
            ->retrieve_submission_object(
                {
                    search_by => { id => $id },
                    obj_type => 'Submission'
                }
            );
    };
    
    if ( $@ ) {
        $c->log->error($@);
        $c->res->redirect($c->uri_for('/error'));
        return;
    }
    
    unless ( $process->{objects} && scalar @{$process->{objects}} ) {
        # Redirect to home screen  in case submission does not exist
        $c->res->redirect($c->uri_for('/'));
        
        return;
    }
    
    $c->stash(
        template => 'submission/form.html',
        form => $process->{objects}->[0],
        answers => $process->{answers},
        view => 1
    );
}

=head2 view_submits

Displays all existent submits.

=cut

sub view_submits :Path('/view_submits') :Args(0) {
    my ( $self, $c ) = @_;
    
    my $process;
    
    eval {
        $process = FormsApp::ProcessFactory
            ->create('read', { schema => $c->model('DB')->schema })
            ->retrieve_objects(
                {
                    opt_args => { order_by => 'created DESC' },
                    obj_type => 'Submission',
                }
            );
    };
    
    if ( $@ ) {
        $c->log->error($@);
        $c->res->redirect($c->uri_for('/error'));
        return;
    }
    
    $c->stash(
        template => 'submission/view_submits.html',
        submits => $process->{objects}
    );
}

=head2 process

Creates submission associated to a form id.
Used as POST submit.

Input:  form id - required

=cut

sub process :Local :Args(0) {
    my ( $self, $c ) = @_;
    
    my $process;
    
    eval {
        $process = FormsApp::ProcessFactory
            ->create('create', { schema => $c->model('DB')->schema })
            ->create_submission(
                {
                    create_with => $c->request->params,
                    obj_type => 'Submission',
                    message => 'Form id missing'
                }
            );
    };
    
    if ( $@ ) {
        $c->log->error($@);
        $c->res->redirect($c->uri_for('/error'));
        return;
    }
    
    if ( $process->{error} ) {
        # Redirect to view forms screen in case form id is not specified
        $c->res->redirect($c->uri_for('/view_forms'));
        
        return;
    }
    
    # Redirect to view submit screen in case process was successful
    $c->res->redirect($c->uri_for('/view_submits'));
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
