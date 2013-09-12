package Teng::Plugin::DBIC::ResultSet;
our $VERSION = "0.04";

use strict;
use warnings;
use utf8;

use Teng::Schema::Table;

our @EXPORT = qw(
    find_or_create
    update_or_create
);

our @EXPORT_TABLE = qw(
    add_unique_constraint
    add_unique_constraints
    name_unique_constraint
    unique_constraints
    unique_constraint_names
    unique_constraint_columns
);

sub init {
    my ($pkg, $self, $opt) = @_;
    my $class = 'Teng::Schema::Table';

    my $alias = delete $opt->{alias_table} || +{};
    {
        no strict 'refs';
        for my $method ( @EXPORT_TABLE ){
            *{$class . '::' . ($alias->{$method} || $method)} = $pkg->can($method);
        }
    }
}

# DBIC::ResultSet
sub find_or_create {
    my ($self, $table_name, $args) = @_;
    my $attrs = scalar @_ > 3 && ref $_[$#_] eq 'HASH' ? $_[$#_] : +{};
    my $table = $self->schema->get_table($table_name);
    my %where;

    my @search_cols = _get_columns_from_unique_constraint($table, $attrs);
    if (! scalar @search_cols) {
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
    my $attrs = scalar @_ > 3 && ref $_[$#_] eq 'HASH' ? $_[$#_] : +{};
    my $table = $self->schema->get_table($table_name);
    my %where;

    my @search_cols = _get_columns_from_unique_constraint($table, $attrs);
    if (! scalar @search_cols) {
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

sub _get_columns_from_unique_constraint {
    my ($table, $attrs) = @_;

    my (@search_cols, $constraint_name);
    if (exists $attrs->{key}) {
        Carp::croak "An undefined 'key' resultset attribute makes no sense"
            if not defined $attrs->{key};
        $constraint_name = $attrs->{key};
    }
    if (not defined $constraint_name or scalar @{$table->primary_keys}) {
        $constraint_name = 'primary';
    }

    if ($constraint_name) {
        @search_cols = $table->unique_constraint_columns($constraint_name);
        Carp::croak "No constraint columns, maybe a malformed '$constraint_name' constraint?"
            unless @search_cols;
    }

    return @search_cols;
}


# DBIC::ResultSource
sub add_unique_constraint {
    my $table = shift;

    if (scalar @_ > 2) {
        Carp::croak 'add_unique_constraint() does not accept multiple constraints, use '
                  . 'add_unique_constraints() instead';
    }

    my $cols = pop @_;
    if (ref $cols ne 'ARRAY') {
        Carp::croak 'Expecting an arrayref of constraint columns, got ' . ($cols||'NOTHING');
    }

    my $name = shift @_;

    $name ||= $table->name_unique_constraint($cols);

    foreach my $col (@$cols) {
        Carp::croak "No such column '$col' on table " . $table->name
            unless $table->row_class->can($col);
    }

    my $unique_constraints = $table->unique_constraints;
    $unique_constraints->{$name} = $cols;
}

sub add_unique_constraints {
    my $table = shift;
    my @constraints = @_;

    if ( !(@constraints % 2) && ref $constraints[0] ne 'ARRAY' ) {
        # with constraint name
        while (my ($name, $constraint) = splice @constraints, 0, 2) {
            $table->add_unique_constraint($name => $constraint);
        }
    }
    else {
        # no constraint name
        foreach my $constraint (@constraints) {
            $table->add_unique_constraint($constraint);
        }
    }
}

sub name_unique_constraint {
    return join '_', shift->name, @_ if @_ > 2;
    return join '_', $_[0]->name, @$_[1];
}

sub unique_constraints {
    my $n = 'unique_constraints';
    $_[0]->{$n} ||= +{ primary => $_[0]->primary_keys };
    return $_[0]->{$n}         if @_ == 1;
    return $_[0]->{$n} = $_[1] if @_ == 2;
    shift->{$n} = @_;
}

sub unique_constraint_names {
    return keys %{$_[0]->unique_constraints};
}

sub unique_constraint_columns {
    my ($table, $constraint_name) = @_;

    my $unique_constraints = $table->unique_constraints;

    Carp::croak "Unknown unique constraint $constraint_name on '" . $table->name . "'"
        unless exists $unique_constraints->{$constraint_name};

    return @{ $unique_constraints->{$constraint_name} };
}

1; # Magic true value required at end of module
__END__

=head1 NAME

Teng::Plugin::DBIC::ResultSet - Teng plugin to append some methods like DBIx::Class::ResultSet

=head1 SYNOPSIS

    package Your::DB;
    use parent 'Teng';
    __PACKAGE__->load_plugin('DBIC::ResultSet');

=head1 DESCRIPTION

Teng::Plugin::DBIC::ResultSet is Teng Plugin to append methods like some DBIx::Class::ResultSet's that.

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

=head1 METHODS FROM DBIC::ResultSource

=head2 add_unique_constraint

=head2 add_unique_constraints

=head2 name_unique_constraint

=head2 unique_constraints

=head2 unique_constraint_names

=head2 unique_constraint_columns

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
#    add_unique_constraints
#    name_unique_constraint
#    unique_constraints
#    unique_constraint_names
#    unique_constraint_columns
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
L<https://github.com/UCormorant/p5-teng-plugin-dbic-resultset/issues>

=head1 AUTHOR

U=Cormorant C<< <u@chimata.org> >>

=head1 LICENCE AND COPYRIGHT

Copyright (C) 2013, U=Cormorant C<< <u@chimata.org> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

=cut

