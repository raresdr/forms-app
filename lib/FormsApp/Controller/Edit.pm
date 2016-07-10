package FormsApp::Controller::Edit;
use Moose;
use namespace::autoclean;

use JSON;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

FormsApp::Controller::Edit - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 begin

Set page title for the current controller (/)

=cut

sub begin :Private {
    my ( $self, $c ) = @_;
    
    $c->stash( page_title => 'Edit Form' );
}

=head2 index

Displays form edit page for a specific form id.

Input: form id - required

=cut

sub index :Path :Args(1) {
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
    
    # redirect to create page in case form is inexistent
    unless ( $process->{objects} && scalar @{$process->{objects}} ) {
        $c->res->redirect($c->uri_for('/create',
            {
                error_msg => "The requested form does not exist",
            })
        );
        return;
    }
    
    $c->stash(
        template => 'edit/edit.html',
        form => $process->{objects}->[0]
    );
}

=head2 view_forms

Displays all existent forms.

=cut

sub view_forms :Path('/view_forms') :Args(0) {
    my ( $self, $c ) = @_;
    
    my $process;
    
    eval {
        $process = FormsApp::ProcessFactory
            ->create('read', { schema => $c->model('DB')->schema })
            ->retrieve_objects(
                {
                    opt_args => { order_by => 'id DESC' },
                    obj_type => 'Form',
                }
            );
    };
    
    if ( $@ ) {
        $c->log->error($@);
        $c->res->redirect($c->uri_for('/error'));
        return;
    }
    
    $c->stash(
        template => 'edit/view_forms.html',
        forms => $process->{objects}
    );
}

=head2 update_title

Updates form's title and description.

Input:  title - required
        description - required

Used with AJAX.

=cut

sub update_title :Local :Args(0) {
    my ( $self, $c ) = @_;
    
    my $process;
    
    eval {
        $process = FormsApp::ProcessFactory
            ->create('update', { schema => $c->model('DB')->schema })
            ->update_object(
                {
                    search_by => { id => $c->request->params->{id} },
                    update_with => {
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
        $c->res->status(500);
        $c->res->body(to_json({ redirect => 'to error page - TO DO' }));
        return;
    }
    
    # since it's AJAX call set error status
    $c->res->status(400)
        if ( $process->{error} );
    $c->res->body(to_json($process));
}

=head2 update_option

Updates form field option.

Used with AJAX.

Input:  option id - required
        description - required

=cut

sub update_option :Local :Args(0) {
    my ( $self, $c ) = @_;
    
    my $process;
    
    eval {
        $process = FormsApp::ProcessFactory
            ->create('update', { schema => $c->model('DB')->schema })
            ->update_object(
                {
                    search_by => { id => $c->request->params->{id} },
                    update_with => {
                        description => $c->request->params->{value}
                    },
                    obj_type => 'FieldOption',
                    message => 'Option id or description missing'
                }
            );
    };
    
    if ( $@ ) {
        $c->log->error($@);
        $c->res->status(500);
        $c->res->body(to_json({ redirect => 'to error page - TO DO' }));
        return;
    }
    
    # since it's AJAX call set error status
    $c->res->status(400)
        if ( $process->{error} );
    $c->res->body(to_json($process));
}

=head2 update_question

Updates form field question.

Used with AJAX.

Input:  field id - required
        description - required

=cut

sub update_question :Local :Args(0) {
    my ( $self, $c ) = @_;
    
    my $process;
    
    eval {
        $process = FormsApp::ProcessFactory
            ->create('update', { schema => $c->model('DB')->schema })
            ->update_object(
                {
                    search_by => { id => $c->request->params->{id} },
                    update_with => {
                        question => $c->request->params->{value}
                    },
                    obj_type => 'FormField',
                    message => 'Field id or question missing'
                }
            );
    };
    
    if ( $@ ) {
        $c->log->error($@);
        $c->res->status(500);
        $c->res->body(to_json({ redirect => 'to error page - TO DO' }));
        return;
    }
    
    # since it's AJAX call set error status
    $c->res->status(400)
        if ( $process->{error} );
    $c->res->body(to_json($process));
}

=head2 create_element

Creates form element.

Used with AJAX.

Input:  form id - required
        description - required
        field type - required

=cut

sub create_element :Local :Args(0) {
    my ( $self, $c ) = @_;
    
    my $field_process;
    my $option_process;
    
    eval {
        # first create the field
        $field_process = FormsApp::ProcessFactory
            ->create('create', { schema => $c->model('DB')->schema })
            ->create_object(
                {
                    create_with => {
                        form_id => $c->request->params->{form_id},
                        field_type_id => $c->request->params->{type},
                        question => 'Question'
                    },
                    obj_type => 'FormField',
                    message => 'Field type or form id missing'
                }
            );
        # if field created successfully, create an option for it
        if ( $field_process->{success} ) {
            $option_process = FormsApp::ProcessFactory
                ->create('create', { schema => $c->model('DB')->schema })
                ->create_object(
                    {
                        create_with => {
                            field_id => $field_process->{object}->id,
                            description => 'Option'
                        },
                        obj_type => 'FieldOption',
                        message => 'Field id or description missing'
                    }
                );
        }
    };
    
    if ( $@ ) {
        $c->log->error($@);
        $c->res->status(500);
        $c->res->body(to_json({ redirect => 'to error page - TO DO' }));
        return;
    }
    
    # since it's AJAX call set error status
    if ( $field_process->{error} || $option_process->{error} ) {
        $c->res->status(400);
        $c->res->body(to_json({
            field_error => $field_process->{error},
            option_error => $option_process->{error}
        }));
        return;
    }
    
    $c->stash(
        template => 'edit/field.html',
        field => $field_process->{object}
    );
}

=head2 add_option

Creates form field option.

Used with AJAX.

Input:  field id - required
        description - required

=cut

sub add_option :Local :Args(0) {
    my ( $self, $c ) = @_;
    
    my $process;
    
    eval {
        $process = FormsApp::ProcessFactory
            ->create('create', { schema => $c->model('DB')->schema })
            ->create_object(
                {
                    create_with => {
                        field_id => $c->request->params->{field_id},
                        description => 'Option'
                    },
                    obj_type => 'FieldOption',
                    message => 'Field id or description missing'
                }
            );
    };
    
    if ( $@ ) {
        $c->log->error($@);
        $c->res->status(500);
        $c->res->body(to_json({ redirect => 'to error page - TO DO' }));
        return;
    }
    
    # add extra params expected from AJAX response
    if ( $process->{success} ) {
        $process->{field_id} = $c->request->params->{field_id};
        $process->{option_id} = $process->{object}->id;
    } else {
        $c->res->status(400);
    }
    
    # in order to not encode objects
    delete $process->{object};
    $c->res->body(to_json($process));
}

=head2 remove_form

Removes form by id.

Used with AJAX.

Input:  form id - required

=cut

sub remove_form :Path('/remove') :Args(0) {
    my ( $self, $c ) = @_;
    
    my $process;
    
    eval {
        $process = FormsApp::ProcessFactory
            ->create('delete', { schema => $c->model('DB')->schema })
            ->remove_object(
                {
                    delete_by => { id => $c->request->params->{id} },
                    obj_type => 'Form',
                    message => 'Form id missing'
                }
            );
    };
    
    if ( $@ ) {
        $c->log->error($@);
        $c->res->status(500);
        $c->res->body(to_json({ redirect => 'to error page - TO DO' }));
        return;
    }
    
    $c->res->status(400)
        if ( $process->{error} );
    
    $c->res->body(to_json($process));
}

=head2 remove_option

Removes option by id.

Used with AJAX.

Input:  option id - required

=cut

sub remove_option :Local :Args(0) {
    my ( $self, $c ) = @_;
    
    my $process;
    
    eval {
        $process = FormsApp::ProcessFactory
            ->create('delete', { schema => $c->model('DB')->schema })
            ->remove_object(
                {
                    delete_by => {
                        id => $c->request->params->{option_id},
                    },
                    obj_type => 'FieldOption',
                    message => 'Option id or field id missing'
                }
            );
    };
    
    if ( $@ ) {
        $c->log->error($@);
        $c->res->status(500);
        $c->res->body(to_json({ redirect => 'to error page - TO DO' }));
        return;
    }
    
    # add extra params expected from AJAX response
    if ( $process->{success} ) {
        $process->{field_id} = $c->request->params->{field_id};
        $process->{option_id} = $c->request->params->{option_id};
    } else {
        $c->res->status(400);
    }
    
    $c->res->body(to_json($process));
}

=head2 remove_field

Removes field by id.

Used with AJAX.

Input:  field id - required

=cut

sub remove_field :Local :Args(0) {
    my ( $self, $c ) = @_;
    
    my $process;
    
    eval {
        $process = FormsApp::ProcessFactory
            ->create('delete', { schema => $c->model('DB')->schema })
            ->remove_object(
                {
                    delete_by => {
                        id => $c->request->params->{field_id},
                    },
                    obj_type => 'FormField',
                    message => 'Field id missing'
                }
            );
    };
    
    if ( $@ ) {
        $c->log->error($@);
        $c->res->status(500);
        $c->res->body(to_json({ redirect => 'to error page - TO DO' }));
        return;
    }
    
    # add extra params expected from AJAX response
    if ( $process->{success} ) {
        $process->{field_id} = $c->request->params->{field_id};
    } else {
        $c->res->status(400);
    }
    
    $c->res->body(to_json($process));
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
