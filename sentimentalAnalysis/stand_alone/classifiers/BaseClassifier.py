import pickle

DELIM = '####$$##%' 
POSITIVE = 'POSITIVE'
NEGATIVE = 'NEGATIVE'
NEUTRAL = 'NEUTRAL'
code_for_category = {
	POSITIVE : 1,
	NEGATIVE : 2,
	NEUTRAL  : 3,
}

category_for_code = dict((v,k) for k, v in code_for_category.iteritems())

class BaseClassifier():

	def train(self, sentences, categories):
		pass

	def save_trained_model(self, filename):
		pass

	def load_trained_model(self, filename):
		pass

	def classify(self, sentences):
		pass

	def classify_single(self, sentence):
		types, confs = self.classify([sentence])
		return (types[0], confs[0])

	def _load_pickle(self, filename):
		return pickle.loads(open(filename).read())

	def _save_pickle(self, filename, obj):
		pickle.dump(obj,open(filename,'wb'))
