-- Sample Query Code
SELECT t.breed, p.pet_id, t.adaptability
FROM dog_traits as t
LEFT JOIN petfinder_dogs as p 
on p.breed = t.breed;

SELECT t.breed, t.adaptability
FROM dog_traits as t
LEFT JOIN dog_links as l 
on l.breed = t.breed;