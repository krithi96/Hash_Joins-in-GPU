# Hash_Joins-in-GPU
Designing a faster Database join of two tables of different sizses by using GPU. The main technique used here is HAS-Tables and Cuckoo Hash joins to make the performance faster than your average join functions.

- In this project, we are implementing a left join of two input tables of different sizes using the hash-join algorithm on a GPU. 
- We used the cuckoo hashing concepts to avoid collision in our hash table. 
- Finally, we did some performance analysis by running our hash-join in different machines,with different table size to see how it scales horizontally. 

 For detailed information refer to the report folder.
