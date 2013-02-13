package Teng::Plugin::DBIC::ResultSet;
use version; our $VERSION = qv('0.01');

use strict;
use warnings;
use utf8;

our @EXPORT = qw(
    find_or_create
    update_or_create
);

sub find_or_create {
    my ($self, $table_name, $args) = @_;
    my $attrs = scalar @_ > 3 && ref $_[$#_] eq 'HASH' ? $_[$#_] : {};
    my $table = $self->schema->get_table($table_name);
    my %where;
    my @search_cols;
    if ($attrs->{key} eq 'primary' or scalar @{$table->primary_keys}) {
        @search_cols = @{$table->primary_keys};
    }
    else {
        @search_cols = @{$table->columns};
    }
    for my $col (@search_cols) {
        $where{$col} = $args->{$col};
    }
    my $row = $self->single($table_name, \%where);
    return $row if $row;
    $self->insert($table_name, $args)->refetch;
}

sub update_or_create {
    my ($self, $table_name, $args) = @_;
    my $attrs = scalar @_ > 3 && ref $_[$#_] eq 'HASH' ? $_[$#_] : {};
    my $table = $self->schema->get_table($table_name);
    my %where;
    my @search_cols;
    if ($attrs->{key} eq 'primary' or scalar @{$table->primary_keys}) {
        @search_cols = @{$table->primary_keys};
    }
    else {
        @search_cols = @{$table->columns};
    }
    for my $col (@search_cols) {
        $where{$col} = delete $args->{$col};
    }
    my $row = $self->single($table_name, \%where);
    if ($row) {
        $row->update($args);
    }
    else {
        $args->{$_} = delete $where{$_} for keys %where;
        $row = $self->insert($table_name, $args)->refetch;
    }
    return $row;
}

1; # Magic true value required at end of module
__END__

=head1 NAME

Teng::Plugin::DBIC::ResultSet - Teng plugin to append some methods like DBIx::Class::ResultSet


=head1 VERSION

This document describes Teng::Plugin::DBIC::ResultSet version 0.01


=head1 SYNOPSIS

  package Your::DB;
  use parent 'Teng';
  __PACKAGE__->load_plugin('DBIC::ResultSet');


=head1 DESCRIPTION

Teng::Plugin::DBIC::ResultSet is Teng Plugin to append methods like some DBIx::Class::ResultSet's one.


=head1 METHODS FROM DBIC::ResultSet

=head2 find_or_create

=head2 update_or_create

# TODO

    new
    search
    search_rs
    search_literal
    find
    search_related
    search_related_rs
    cursor
    single
    get_column
    search_like
    slice
    next
    result_source
    result_class
    count
    count_rs
    count_literal
    all
    reset
    first
    update
    update_all
    delete
    delete_all
    populate
    pager
    page
    new_result
    as_query
    find_or_new
    create
#    find_or_create
#    update_or_create
    update_or_new
    get_cache
    set_cache
    clear_cache
    is_paged
    is_ordered
    related_resultset
    current_source_alias
    as_subselect_rs
    throw_exception


=head1 METHODS from DBIC::ResultSource

=head2 add_unique_constraint

# TODO

    add_column
    has_column
    column_info
    columns
    columns_info
    remove_columns
    remove_column
    set_primary_key
    primary_columns
    sequence
#    add_unique_constraint
    add_unique_constraints
    name_unique_constraint
    unique_constraints
    unique_constraint_names
    unique_constraint_columns
    sqlt_deploy_callback
    default_sqlt_deploy_hook
    result_class
    resultset
    resultset_class
    resultset_attributes
    name
    source_name
    from
    schema
    storage
    add_relationship
    relationships
    relationship_info
    has_relationship
    reverse_relationship_info
    related_source
    related_class
    handle
    throw_exception
    source_info
    new
    column_info_from_storage 
=head1 BUGS AND LIMITATIONS

Please report any bugs or feature requests to
L<https://github.com/UCormorant/p5-teng-plugin-dbicic/issues>


=head1 AUTHOR

U=Cormorant  C<< <u@chimata.org> >>


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2013, U=Cormorant C<< <u@chimata.org> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.


=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.
