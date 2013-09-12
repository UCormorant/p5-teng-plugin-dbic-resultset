# NAME

Teng::Plugin::DBIC::ResultSet - Teng plugin to append some methods like DBIx::Class::ResultSet



# VERSION

This document describes Teng::Plugin::DBIC::ResultSet version 0.03



# SYNOPSIS

    package Your::DB;
    use parent 'Teng';
    __PACKAGE__->load_plugin('DBIC::ResultSet');



# DESCRIPTION

Teng::Plugin::DBIC::ResultSet is Teng Plugin to append methods like some DBIx::Class::ResultSet's that.



# METHODS FROM DBIC::ResultSet

## find\_or\_create

## update\_or\_create

\# TODO

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



# METHODS FROM DBIC::ResultSource

## add\_unique\_constraint

## add\_unique\_constraints

## name\_unique\_constraint

## unique\_constraints

## unique\_constraint\_names

## unique\_constraint\_columns

\# TODO

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



# BUGS AND LIMITATIONS

Please report any bugs or feature requests to
[https://github.com/UCormorant/p5-teng-plugin-dbic-resultset/issues](https://github.com/UCormorant/p5-teng-plugin-dbic-resultset/issues)



# AUTHOR

U=Cormorant `<u@chimata.org>`



# LICENCE AND COPYRIGHT

Copyright (c) 2013, U=Cormorant `<u@chimata.org>`. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See [perlartistic](http://search.cpan.org/perldoc?perlartistic).
