package FormsApp::Processes::Read;

use Moose;

extends 'FormsApp::Process';

sub retrieve_objects {
    my ( $self, $args ) = @_;
    
    $args->{search_by} ||= {};
    $args->{opt_args} ||= {};
    
    my @objects = $self->schema->resultset($args->{obj_type})
        ->search($args->{search_by}, $args->{opt_args});
    
    return { objects => \@objects };
}

# special sub for retrieving an existent submission with its reponses
# too specific to use a generic function
sub retrieve_submission_object {
    my ( $self, $args ) = @_;
    
    my $return_obj = $self->retrieve_objects($args);
    
    return { objects => [] }
        unless ( $return_obj->{objects} && scalar @{$return_obj->{objects}} );
    
    my $submission_obj = $return_obj->{objects}->[0];
    my $form = $submission_obj->form;
    
    my @answers = $self->schema->resultset('Answer')->search({ submission_id => $submission_obj->id });
    my $answer_hash;
    map { push @{$answer_hash->{$_->field_id}}, $_->option_id } @answers;
    
    return { objects => [ $form ], answers => $answer_hash };
}

__PACKAGE__->meta()->make_immutable();

1;

__END__

=head1 NAME

FormsApp::Processes::Edit - Application Class used for read operations