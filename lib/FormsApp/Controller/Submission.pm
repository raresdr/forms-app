package FormsApp::Controller::Submission;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

FormsApp::Controller::Complete - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path('complete') :Args(1) {
    my ( $self, $c, $id ) = @_;
    
    my $form = $c->model('DB::Form')->find({ id => $id });
    
    use Data::Dumper;
    $Data::Dumper::Indent = 1;
    warn Dumper($c->request->params);
    
    unless ( $form ) {
        # Redirect to home screen  in case form does not exist
        $c->res->redirect($c->uri_for('/'));
        
        return;
    }
    
    $c->stash(
        template => 'submission/form.html',
        form => $form
    );
}

sub process :Local :Args(0) {
    my ( $self, $c ) = @_;
    
    my $params = $c->request->params;
    
    use Data::Dumper;
    $Data::Dumper::Indent = 1;
    warn Dumper($c->request->params);
    
    unless ( $params->{form_id} ) {
        # Redirect to home screen  in case form id is not specified
        $c->res->redirect($c->uri_for('/'));
        
        return;
    }
    
    # Create submission
    my $submission = $c->model('DB::Submission')->create({
        form_id   => $params->{form_id},
    });
    
    foreach my $field_id ( keys %$params ) {
        next
            unless ( $field_id && $field_id =~ /^\d+$/ && $params->{$field_id} );
        
        my $options = ( ref $params->{$field_id} eq "ARRAY" )
            ? $params->{$field_id}
            : [ $params->{$field_id} ];
        warn Dumper($options);
        foreach my $op_id ( @$options ) {
            $submission->add_to_answers({
                submission_id => $submission->id,
                field_id => $field_id,
                option_id => $op_id
            });
        }
    }
    
    $c->res->redirect($c->uri_for('/'));
}

sub view :Path('view') :Args(1) {
    my ( $self, $c, $id ) = @_;
    
    my $submission = $c->model('DB::Submission')->find({ id => $id });
    
    use Data::Dumper;
    $Data::Dumper::Indent = 1;
    #warn Dumper($c->request->params);
    
    unless ( $submission ) {
        # Redirect to home screen  in case submission does not exist
        $c->res->redirect($c->uri_for('/'));
        
        return;
    }
    
    my $form = $submission->form;
    #warn Dumper($form);
    my @answers = my @forms = $c->model('DB::Answer')->search({ submission_id => $submission->id });
    my $answer_hash;
    map { push @{$answer_hash->{$_->field_id}}, $_->option_id } @answers;
    
    $c->stash(
        template => 'submission/form.html',
        form => $form,
        answers => $answer_hash,
        view => 1
    );
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
