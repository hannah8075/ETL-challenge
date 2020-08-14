DROP TABLE IF EXISTS petfinder_dogs;
DROP TABLE IF EXISTS dog_links;
DROP TABLE IF EXISTS dog_traits;

CREATE TABLE petfinder_dogs (
	city text,
	state text,
	pet_id integer primary key,
	name text,
	breed text
);

create table dog_links (
	breed varchar primary key,
	link varchar
);
create table dog_traits (
	breed varchar primary key,
	adaptability int,
	all_around_friendliness int,
	health_and_grooming_needs int,
	trainability int,
	physical_needs int
	
);