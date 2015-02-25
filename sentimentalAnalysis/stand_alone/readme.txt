Different Classifier Implementations
------------------------------------

1. Simple => Sum positive and negatives scores (from SentiwordNet) of each word and classify based on these sums.
2. Ngarm  => Similar to simple classifer, but uses {uni,bi,tri}_grams instead of words
3. LinearSVM => Implementaion of scikit-learn LinearSVM (with Bag-of-Ngram representation)

Notes:-
-----

1. ####$$##% is used as a delimitor in datasets

