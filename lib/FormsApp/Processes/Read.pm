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

__PACKAGE__->meta()->make_immutable();

1;

__END__

=head1 NAME

FormsApp::Processes::Edit - Application Class used for read operations