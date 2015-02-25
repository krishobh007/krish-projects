import re

import classifiers.BaseClassifier as BaseClassifier

class SimpleClassifier(BaseClassifier.BaseClassifier):

	def __init__(self):
		self.TYPE_CONSTANT = 0.5

	def __tokenize(self, sentence):
		return re.findall(r"[\w']+", sentence)
			
	def train(self, sentences, categories):
		print 'Not Implemented Yet!'

	def save_trained_model(self, filename):
		self._save_pickle(filename, self.scores)

	def load_trained_model(self, filename):
		self.scores = self._load_pickle(filename)

	def classify(self, sentences):
		
		def __get_score(scores, word):
			try:
				positive_score = float(scores[word][0]['PosScore'])
				negative_score = float(scores[word][0]['NegScore'])
			except KeyError:
				positive_score = 0.0
				negative_score = 0.0
			return (positive_score, negative_score)

		def __calculate_confidence_level(diff):
			return 1 - 2*(abs(diff))

		sentences_types, confidences = [], []

		for sentence in sentences:
			total_positives, total_negatives = 0.0, 0.0
			for word in self.__tokenize(sentence):
				if len(word) != 0:
					postive_score, negative_score = __get_score(self.scores, word)
					total_positives += postive_score
					total_negatives += negative_score

			diff = total_positives - total_negatives 
			confidence_value = __calculate_confidence_level(diff)

			if -(self.TYPE_CONSTANT) < diff < self.TYPE_CONSTANT:
				sentence_type = BaseClassifier.code_for_category[BaseClassifier.NEUTRAL]
			elif diff >= self.TYPE_CONSTANT:
				sentence_type = BaseClassifier.code_for_category[BaseClassifier.POSITIVE]
			elif diff <= -(self.TYPE_CONSTANT):
				sentence_type = BaseClassifier.code_for_category[BaseClassifier.NEGATIVE]

			sentences_types.append(sentence_type)
			confidences.append(confidence_value)

		return (sentences_types, confidences)
