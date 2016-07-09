use utf8;
package FormsApp::Schema::Result::FieldOption;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

FormsApp::Schema::Result::FieldOption

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

=head1 TABLE: C<field_options>

=cut

__PACKAGE__->table("field_options");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 field_id

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=head2 description

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "field_id",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
  "description",
  { data_type => "varchar", is_nullable => 0, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 answers

Type: has_many

Related object: L<FormsApp::Schema::Result::Answer>

=cut

__PACKAGE__->has_many(
  "answers",
  "FormsApp::Schema::Result::Answer",
  { "foreign.option_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

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


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-07-04 18:40:17
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:SmM2Pcj7WuKOlLJeeC+G6Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
