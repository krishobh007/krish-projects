from django.http import HttpResponseRedirect, HttpResponse
from django.utils import simplejson

import pickle
import classifiers.linearsvm.LinearSvmClassifier as LinearSvmClassifier
import classifiers.BaseClassifier as BaseClassifier
import sys

def home(request):
    return HttpResponse("Sentimental Analysis API PAGE, Request should be JSON format[{message:<Message>, context:<Context>}]")

contexts = {
    'airtel' : "/models/airtel_svm.pkl",
    'test'   : "/models/test_svm.pkl",
    'rose'   : "/models/rose_svm.pkl",
}

def getAnalyse(request):
    print "DBG: API getAnalyse is starting"
    if request.method != "POST":
        result = {"data":{}, "status":"-1","message":"Only accept post Method"}
    elif 'api_key' not in request.POST or request.POST['api_key']!='SECRET':
        result = {"data":{}, "status":"-1","message":"Please verify API key"}
    elif 'message' not in request.POST:
        result = {"data":{}, "status":"-1","message":"Please provide message argument"}
    elif 'context' not in request.POST or request.POST['context'] not in contexts.keys():
        result = {"data":{}, "status":"-1","message":"Please provide a valid context argument"}
    else :
        SVM_MODEL = sys.path[0] + contexts[request.POST['context']]
        message = request.POST['message']
        classifier = LinearSvmClassifier.LinearSvmClassifier() 
        classifier.load_trained_model(SVM_MODEL) 
        sentiment, confidence = classifier.classify_single(message)
        result = {"data": {"sentiment":BaseClassifier.category_for_code[sentiment],
                           "confidence":confidence},
                  "status":"1","message":"ok"}
    resp = HttpResponse(simplejson.dumps(result), content_type='application/json')
    resp["Access-Control-Allow-Origin"] = "*"
    return resp
