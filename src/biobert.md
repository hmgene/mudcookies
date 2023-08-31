// @hmgene took 4 hours to figure this out

## Installation
* Note, python < 3.7.2 - numpy issue
python >= 3.8 torch issue.

```
conda create -n py372 python==3.7.2
conda activate py372
pip install numpy
pip install torch==1.2.0
pip install biobert-embedding
```

* download the model manually from 
https://www.dropbox.com/s/hvsemunmv0htmdk/biobert_v1.1_pubmed_pytorch_model.tar.gz
( the google drive is not working ).
* run the following:
```
from biobert_embedding.embedding import BiobertEmbedding

text = "Breast cancers with HER2 amplification have a higher risk of CNS metastasis and poorer prognosis."\

# Class Initialization (You can set default 'model_path=None' as your finetuned BERT model path while Initialization)
biobert = BiobertEmbedding();

word_embeddings = biobert.word_vector(text)
sentence_embedding = biobert.sentence_vector(text)

print("Text Tokens: ", biobert.tokens)
# Text Tokens:  ['breast', 'cancers', 'with', 'her2', 'amplification', 'have', 'a', 'higher', 'risk', 'of', 'cns', 'metastasis', 'and', 'poorer', 'prognosis', '.']

print ('Shape of Word Embeddings: %d x %d' % (len(word_embeddings), len(word_embeddings[0])))
# Shape of Word Embeddings: 16 x 768

print("Shape of Sentence Embedding = ",len(sentence_embedding))
# Shape of Sentence Embedding =  768
```
