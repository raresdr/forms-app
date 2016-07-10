package FormsApp::Processes::Create;

use Moose;

extends 'FormsApp::Process';

sub create_object {
    my ( $self, $args ) = @_;
    
    $args->{create_with} ||= {};
    
    my $missing_create_args = grep { !$_ } values %{$args->{create_with}};
    
    # return error flag on create args missing
    if ( $missing_create_args ) {
        return { error => 1, message => $args->{message} || 'missing args' };
    }
    
    my $object = $self->schema->resultset($args->{obj_type})
        ->create($args->{create_with});
    
    return { success => 1, object => $object };
}

# special sub for creating a submission
# too specific to use a generic function
sub create_submission {
    my ( $self, $args ) = @_;
    
    $args->{create_with} ||= {};
    
    # return error flag on create args missing
    unless ( $args->{create_with}->{form_id} ) {
        return { error => 1, message => $args->{message} || 'missing args' };
    }
    
    my $submission_object = $self->schema->resultset($args->{obj_type})
        ->create({ form_id => $args->{create_with}->{form_id} });
    
    foreach my $field_id ( keys %{$args->{create_with}} ) {
        next
            unless ( $field_id && $field_id =~ /^\d+$/ && $args->{create_with}->{$field_id} );
        
        my $options = ( ref $args->{create_with}->{$field_id} eq "ARRAY" )
            ? $args->{create_with}->{$field_id}
            : [ $args->{create_with}->{$field_id} ];
            
        foreach my $op_id ( @$options ) {
            $submission_object->add_to_answers({
                submission_id => $submission_object->id,
                field_id => $field_id,
                option_id => $op_id
            });
        }
    }
    
    return { success => 1 };
}

__PACKAGE__->meta()->make_immutable();

1;

__END__

=head1 NAME

FormsApp::Processes::Create - Application Class used for create operations