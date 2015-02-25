from sklearn import svm
from sklearn.feature_extraction.text import CountVectorizer

from classifiers import BaseClassifier

class LinearSvmClassifier(BaseClassifier.BaseClassifier):

    def train(self, sentences, categories):
        self.classifier = svm.LinearSVC(class_weight='auto')
        self.vectorizer = CountVectorizer(ngram_range=(1,3), binary=True)
        training_features = self.vectorizer.fit_transform(sentences)
        self.classifier.fit(training_features, categories)

    def save_trained_model(self, filename):
        self._save_pickle(filename, (self.classifier, self.vectorizer))

    def load_trained_model(self, filename):
        self.classifier, self.vectorizer = self._load_pickle(filename)

    def classify(self, sentences):
        predictions = self.classifier.predict(self.vectorizer.transform(sentences))
        return (list(predictions), [0]*len(sentences)) 
