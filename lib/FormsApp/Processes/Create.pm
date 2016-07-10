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

__PACKAGE__->meta()->make_immutable();

1;

__END__

=head1 NAME

FormsApp::Processes::Create - Application Class used for create operations