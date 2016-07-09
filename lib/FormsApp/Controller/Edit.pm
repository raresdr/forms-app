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

=cut

sub index :Path :Args(1) {
    my ( $self, $c, $id ) = @_;
    
    my $form = $c->model('DB::Form')->find({ id => $id });
    
    unless ( $form ) {
        warn 'no form';
        # Redirect to /create in case form is inexistent
        $c->res->redirect($c->uri_for('/create',
            {
                error_msg => "The accessed form does not exist",
            })
        );
        return;
    }
    
    $c->stash(
        template => 'edit/edit.html',
        form => $form
    );
}

=head2 list_forms

=cut

sub list_forms :Path('/list_forms') :Args(0) {
    my ( $self, $c ) = @_;
    
    my @forms = $c->model('DB::Form')->search({}, {order_by => 'id DESC'});
    
    $c->stash(
        template => 'edit/view_forms.html',
        forms => \@forms
    );
}

=head2 index

=cut

sub update_title :Local :Args(0) {
    my ( $self, $c ) = @_;
    
    use Data::Dumper;
    $Data::Dumper::Indent = 1;
    
    my $id = $c->request->params->{id};
    my $title = $c->request->params->{title};
    my $description = $c->request->params->{description};
    warn"$title|$description|";
    warn Dumper($c->request->params);
    unless ( $id && $title && $description ) {
        $c->res->body(to_json({
            error => 1, message => 'Required fields missing'
        }));
        return;
    }
    
    warn 'still in process_desc';
    my $form_rs = $c->model('DB::Form')->search({ id => $id });
    $form_rs->update({
        title => $title,
        description => $description
    });
    
    $c->res->body(to_json({
        success => 1,
        message => "Form with id $id updated"
    }));
}

sub create_element :Local :Args(0) {
    my ( $self, $c ) = @_;
    
    my $form_id = $c->request->params->{form_id};
    my $type = $c->request->params->{type};
    
    unless ( $type && $form_id ) {
        warn 'no type or form id';
        $c->res->body( 'error - no type or form_id specified');
        return;
    }
    
    # Create field
    my $field = $c->model('DB::FormField')->create({
        form_id => $form_id,
        field_type_id => $type,
        question => 'Question'
    });
    
    my $option = $field->add_to_field_options({ description => 'Option' });
    
    $c->stash(
        template => 'edit/field.html',
        field => $field
    );
}

sub add_option :Local :Args(0) {
    my ( $self, $c ) = @_;
    use Data::Dumper;
    $Data::Dumper::Indent = 1;
    #warn Dumper($c->request->params);
    my $field_id = $c->request->params->{field_id};
    
    unless ( $field_id ) {
        $c->res->body( 'error - no field_id specified');
        return;
    }
    
    # Create option
    my $option = $c->model('DB::FieldOption')->create({
        field_id => $field_id,
        description => 'Option'
    });
    
    $c->res->body(to_json({
        success => 1,
        message => "Option created",
        option_id => $option->id,
        field_id => $field_id
    }));
}

sub remove_option :Local :Args(0) {
    my ( $self, $c ) = @_;
    use Data::Dumper;
    $Data::Dumper::Indent = 1;
    #warn Dumper($c->request->params);
    my $option_id = $c->request->params->{option_id};
    my $field_id = $c->request->params->{field_id};
    
    unless ( $option_id && $field_id ) {
        $c->res->body( 'error - no option_id or field_id specified');
        return;
    }
    
    # Remove option
    my $option = $c->model('DB::FieldOption')->find({ id => $option_id });
    $option->delete;
    
    $c->res->body(to_json({
        success => 1,
        message => "Option deleted",
        option_id => $option_id,
        field_id => $field_id
    }));
}

sub remove_field :Local :Args(0) {
    my ( $self, $c ) = @_;
    use Data::Dumper;
    $Data::Dumper::Indent = 1;
    #warn Dumper($c->request->params);
    my $field_id = $c->request->params->{field_id};
    
    unless ( $field_id ) {
        $c->res->body( 'error - no field_id specified');
        return;
    }
    
    # Create option
    my $field = $c->model('DB::FormField')->find({ id => $field_id });
    $field->delete;
    
    $c->res->body(to_json({
        success => 1,
        message => "Field deleted",
        field_id => $field_id
    }));
}

sub update_option :Local :Args(0) {
    my ( $self, $c ) = @_;
    use Data::Dumper;
    $Data::Dumper::Indent = 1;
    #warn Dumper($c->request->params);
    my $id = $c->request->params->{id};
    my $value = $c->request->params->{value};
    
    unless ( $id && $value ) {
        $c->res->body( 'error - no option_id or description specified');
        return;
    }
    
    # Update option
    my $rs = $c->model('DB::FieldOption')->search({ id => $id });
    $rs->update({ description => $value });
    
    $c->res->body(to_json({
        success => 1,
        message => "Option with id $id updated"
    }));
}

sub update_question :Local :Args(0) {
    my ( $self, $c ) = @_;
    use Data::Dumper;
    $Data::Dumper::Indent = 1;
    warn Dumper($c->request->params);
    my $id = $c->request->params->{id};
    my $value = $c->request->params->{value};
    
    unless ( $id && $value ) {
        warn 'no field_id or question';
        $c->res->body( 'error - no field_id or question specified');
        return;
    }
    
    # Update option
    my $rs = $c->model('DB::FormField')->search({ id => $id });
    $rs->update({ question => $value });
    
    $c->res->body(to_json({
        success => 1,
        message => "Field with id $id updated"
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
