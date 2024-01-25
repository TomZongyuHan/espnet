import nltk

nltk.set_proxy('127.0.0.1:7890')
print('set nltk proxy successful!')
nltk.download('cmudict')
nltk.download('averaged_perceptron_tagger')
print('averaged_perceptron_tagger and cmudict download successful!')

try:
    nltk.data.find('corpora/cmudict.zip')
    print('find cmudict in local!')
except LookupError:
    print('notfind')

try:
    nltk.data.find('taggers/averaged_perceptron_tagger.zip')
    print('find averaged_perceptron_tagger in local!')
except LookupError:
    print('notfind')