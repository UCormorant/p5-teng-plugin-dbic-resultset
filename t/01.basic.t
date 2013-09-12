use Test::More;
use t::TestDB;

my $db = t::TestDB->new;

plan tests => 4;

subtest 'find_or_create' => sub {
    $db->create_test_data();

    # find
    my $user_count = $db->find_or_create('user_count', { id => 1, user_id => 10 });
    is $user_count->count, 1000, 'find';

    # create
    my $args = { id => 3, user_id => 40, count => 4000 };
    $user_count = $db->find_or_create('user_count', $args);
    is $user_count->count, 4000, 'create';

    # find again
    $user_count = $db->find_or_create('user_count', $args);
    is $user_count->count, 4000, 'find again';

    # check using primary keys only
    $args->{count} = 0;
    $user_count = $db->find_or_create('user_count', $args); # ignore count
    is $user_count->count, 4000, 'check using primary keys only';
};

subtest 'update_or_create' => sub {
    $db->create_test_data();

    # update
    my $user_count = $db->update_or_create('user_count', { id => 1, user_id => 10, count => 1001 });
    is $user_count->count, 1001, 'update';

    # create
    my $args = { id => 3, user_id => 40, count => 4000 };
    $user_count = $db->update_or_create('user_count', $args);
    is $user_count->count, 4000, 'create';

    # update again
    $args->{count}++;
    $user_count = $db->update_or_create('user_count', $args);
    is $user_count->count, 4001, 'update again';

    # check using primary keys only
    $args->{count} = 0;
    $user_count = $db->find_or_create('user_count', $args); # ignore count
    is $user_count->count, 4001, 'check using primary keys only';
};

subtest 'add_unique_constraints' => sub {
    $db->create_test_data();

    pass;
};

subtest 'get_unique_constraints' => sub {
    $db->create_test_data();

    pass;
};

done_testing;
