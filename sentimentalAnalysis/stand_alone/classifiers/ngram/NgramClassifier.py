import nltk
from nltk.tokenize import word_tokenize

from classifiers import BaseClassifier

class NgramClassifier(BaseClassifier.BaseClassifier):

    def __tokenize(self, sentence):
        results, word_list = [], []
        word_list.extend(word_tokenize(sentence))
        gram_list = nltk.trigrams(word_list)
        gram_list.extend(nltk.bigrams(word_list))
        for words in word_list:
            unigrams = (words,)
            gram_list.append(unigrams)
        for tuples in gram_list:
            key = (' ').join(tuples)
            results.append(key)
        return results

    def __dict_generator(self, training_sentences, training_categories):
        resultant_dict = {}
        for i in range(len(training_sentences)):
            if training_categories[i] == BaseClassifier.code_for_category[BaseClassifier.POSITIVE]:
                classifier = 1.0
            elif training_categories[i] == BaseClassifier.code_for_category[BaseClassifier.NEGATIVE]:
                classifier = -1.0
            else:
                classifier = 0.0
            for key in self.__tokenize(training_sentences[i]):
                # Searching for existing key_value.Update existing list if found.
                if key not in resultant_dict:
                    resultant_dict[key] = []
                resultant_dict[key].append(classifier)
        training_dict = {}
        for key in resultant_dict:
            training_dict[key] = sum(resultant_dict[key])/len(resultant_dict[key])
        return training_dict
    
    def train(self, sentences, categories):
        self.scores = self.__dict_generator(sentences, categories)

    def save_trained_model(self, filename):
        self._save_pickle(filename, self.scores)

    def load_trained_model(self, filename):
        self.scores = self._load_pickle(filename)

    def classify(self, sentences):
        results, confidences = [], []
        for sentence in sentences:
            tokens = self.__tokenize(sentence)
            total_score = 0.0
            for token in tokens:
                if token in self.scores:
                    total_score += self.scores[token]    
            result = BaseClassifier.NEUTRAL
            if total_score > 0.0:
                result = BaseClassifier.code_for_category[BaseClassifier.POSITIVE]
            elif total_score < 0.0:
                result = BaseClassifier.code_for_category[BaseClassifier.NEGATIVE]
            results.append(result)
            confidences.append(0)
        return results, confidences
