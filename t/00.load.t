use Test::More tests => 3;

BEGIN {
use_ok( 'Uc::Teng::Plugin' );
use_ok( 'Uc::Teng::Plugin::FindOrCreate' );
use_ok( 'Uc::Teng::Plugin::UpdateOrCreate' );
}

diag( "Testing Uc::Teng::Plugin ".Uc::Teng::Plugin->VERSION );
