use strict;
use Test::More;
use DataGen::FromDDL;

my $ddl = <<EOL;
CREATE TABLE blogs (
    `id` int unsigned NOT NULL AUTO_INCREMENT,
    `author_id` int unsigned NOT NULL,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`author_id`) REFERENCES `users` (`id`)
);

CREATE TABLE users (
    `id` int unsigned NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (`id`),
);
EOL

my $generator = DataGen::FromDDL->new({
    ddl => $ddl,
    parser => 'mysql',
});

my $output;
open my $out_fh, '>', \$output;
$generator->generate(3, $out_fh);

my $expect = qr/INSERT INTO `users` \(`id`\) VALUES \(1\),\(2\),\(3\);
INSERT INTO `blogs` \(`id`,`author_id`\) VALUES \(1,(\d)\),\(2,(\d)\),\(3,(\d)\);
/;
if ($output =~ $expect) {
    ok $1 >= 1 && $1 <=3;
    ok $2 >= 1 && $2 <=3;
    ok $3 >= 1 && $3 <=3;
} else {
    fail;
}

done_testing;
