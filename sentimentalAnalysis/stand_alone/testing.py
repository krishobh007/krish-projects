import argparse

import classifiers.simple.SimpleClassifier as SimpleClassifier
import classifiers.ngram.NgramClassifier as NgramClassifier
import classifiers.linearsvm.LinearSvmClassifier as LinearSvmClassifier
import classifiers.BaseClassifier as BaseClassifier

def get_data(file):
    sentences, categories = [], []
    for line in open(file).readlines():
        sentence, category = line.rstrip().split(BaseClassifier.DELIM)
        sentences.append(sentence.lower())
        categories.append(BaseClassifier.code_for_category[category])
    return sentences, categories

def show_stats(predictions, testing_categories):

    def __store_details(details, correct, found):
        if correct not in details:
            details[correct] = {}
        if found not in details[correct]:
            details[correct][found] = 0
        details[correct][found] += 1

    def __print_details(details):
        for c in BaseClassifier.code_for_category.keys():
            print('\t' + c[:3]),
        for ori_cat, ori_code in BaseClassifier.code_for_category.items():
            print('\n' + ori_cat[:3]),
            if ori_code not in details:
                details[ori_code] = {}
            for new_cat, new_code in BaseClassifier.code_for_category.items():
                cnt = details[ori_code][new_code] if new_code in details[ori_code] else 0
                print('\t' + str(cnt)),

    failure_count, success_count = 0, 0
    details = {}
    for i in range(0,len(predictions)):
        if predictions[i] != testing_categories[i]:
            failure_count += 1
        else:
            success_count += 1
        __store_details(details, testing_categories[i], predictions[i])
    print '\nSuccess count : ', success_count
    print 'Failure count : ', failure_count
    print 'Accuracy(%)   : ', (100.0 * success_count)/len(predictions)
    print "\nDetails (row: correct category, col: predicted category)\n"
    __print_details(details)
    
def main(training_file, trained_model, new_trainined_model, testing_file, clf):
    if training_file is None:
        print '+ Begining to load trained model'
        clf.load_trained_model(trained_model)
    else:
        print '+ Begining to train model'
        training_sentences, training_categories = get_data(training_file)
        clf.train(training_sentences, training_categories)
        if new_trainined_model:
            print '+ Begining to save train model'
            clf.save_trained_model(new_trained_model)
    print '+ Begining to classify using trained model'
    testing_sentences, testing_categories = get_data(testing_file)
    predictions = clf.classify(testing_sentences)
    show_stats(predictions[0], testing_categories)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Train classifier using given training input \
                                                  and benchmark using given testing input')
    parser.add_argument('--train', nargs=1, dest='training_file', 
                        help='File containing training data')
    parser.add_argument('--load', nargs=1, dest='trained_model', 
                        help='File containing trained model')
    parser.add_argument('--save', nargs=1, dest='new_trained_model', 
                        help='File to store trained model')
    parser.add_argument('--test', nargs=1, required=True, dest='testing_file',
                        help='File containing testing data')
    parser.add_argument('--classifier', nargs=1, required=True, dest='classifier',
                        help='Classifier to use', choices=['simple', 'ngram', 'linearsvm'])
    args = parser.parse_args()
    if args.classifier[0] == 'simple':
        clf = SimpleClassifier.SimpleClassifier()
    elif args.classifier[0] == 'ngram':
        clf = NgramClassifier.NgramClassifier()
    else:
        clf = LinearSvmClassifier.LinearSvmClassifier()
    input_file = None if args.training_file is None else args.training_file[0]
    trained_model = None if args.trained_model is None else args.trained_model[0]
    new_trained_model = None if args.new_trained_model is None else args.new_trained_model[0]
    main(input_file, trained_model, new_trained_model, args.testing_file[0], clf)
