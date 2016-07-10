package FormsApp::Processes::Delete;

use Moose;

extends 'FormsApp::Process';

sub remove_object {
    my ( $self, $args ) = @_;
    
    $args->{delete_by} ||= {};
    
    my $missing_delete_args = grep { !$_ } values %{$args->{delete_by}};
    
    # return error flag on delete args missing
    if ( $missing_delete_args ) {
        return { error => 1, message => $args->{message} || 'missing args' };
    }
    
    my $obj = $self->schema->resultset($args->{obj_type})
        ->find($args->{delete_by});
    $obj->delete();
    
    return { success => 1, message => "Object deleted" };
}

__PACKAGE__->meta()->make_immutable();

1;

__END__

=head1 NAME

FormsApp::Processes::Edit - Application Class used for update operations