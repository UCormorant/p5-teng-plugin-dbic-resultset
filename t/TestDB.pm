package t::TestDB;

use strict;
use warnings;
use parent 'Teng';
__PACKAGE__->load_plugin('DBIC::ResultSet');

sub new {
    my $class = shift;
    $class->SUPER::new(
        connect_info => [
            'dbi:SQLite::memory:',
            '',
            '',
            {RaiseError => 1, PrintError => 0, AutoCommit => 1},
        ],
    );
}

sub create_test_data {
    $_[0]->do(q{DROP TABLE IF EXISTS user_count});
    $_[0]->do(q{
CREATE TABLE user_count (
id INTEGER,
user_id INTEGER,
count INTEGER,
primary key (id, user_id)
);
});
    $_[0]->insert('user_count', { id => 1, user_id => 10, count => 1000 });
    $_[0]->insert('user_count', { id => 2, user_id => 20, count => 2000 });
    $_[0]->insert('user_count', { id => 3, user_id => 40, count => 4000 });
}

package t::TestDB::Schema;
use strict;
use warnings;
use Teng::Schema::Declare;

table {
    name 'user_count';
    pk qw( id user_id );
    columns qw( id user_id count );
};

1;
