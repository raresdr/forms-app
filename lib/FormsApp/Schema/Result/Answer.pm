use utf8;
package FormsApp::Schema::Result::Answer;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

FormsApp::Schema::Result::Answer

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=item * L<DBIx::Class::TimeStamp>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp");

=head1 TABLE: C<answers>

=cut

__PACKAGE__->table("answers");

=head1 ACCESSORS

=head2 submission_id

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=head2 field_id

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=head2 option_id

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "submission_id",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
  "field_id",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
  "option_id",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</submission_id>

=item * L</field_id>

=back

=cut

__PACKAGE__->set_primary_key("submission_id", "field_id", "option_id");

=head1 RELATIONS

=head2 field

Type: belongs_to

Related object: L<FormsApp::Schema::Result::FormField>

=cut

__PACKAGE__->belongs_to(
  "field",
  "FormsApp::Schema::Result::FormField",
  { id => "field_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 option

Type: belongs_to

Related object: L<FormsApp::Schema::Result::FieldOption>

=cut

__PACKAGE__->belongs_to(
  "option",
  "FormsApp::Schema::Result::FieldOption",
  { id => "option_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 submission

Type: belongs_to

Related object: L<FormsApp::Schema::Result::Submission>

=cut

__PACKAGE__->belongs_to(
  "submission",
  "FormsApp::Schema::Result::Submission",
  { id => "submission_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-07-03 17:27:29
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:PI4mrlBVtCX4uUqPe+d3ng


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
