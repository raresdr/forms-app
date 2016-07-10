package FormsApp::Processes::Update;

use Moose;

extends 'FormsApp::Process';

sub update_object {
    my ( $self, $args ) = @_;
    
    $args->{search_by} ||= {};
    $args->{update_with} ||= {};
    
    my $missing_search_args = grep { !$_ } values %{$args->{search_by}};
    my $missing_update_args = grep { !$_ } values %{$args->{update_with}};
    warn $missing_search_args;
    warn $missing_update_args;
    # return error flag on search/update args missing
    if ( $missing_search_args || $missing_update_args ) {
        return { error => 1, message => $args->{message} || 'missing args' };
    }
    
    my $obj_rs = $self->schema->resultset($args->{obj_type})
        ->search($args->{search_by});
    $obj_rs->update($args->{update_with});
    
    return { success => 1, message => "Object updated" };
}

__PACKAGE__->meta()->make_immutable();

1;

__END__

=head1 NAME

FormsApp::Processes::Edit - Application Class used for update operations