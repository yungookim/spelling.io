word-prediction-api
===================
  
Experimental Project
  
Word prediction and correction REST API built with corpus extracted from Wikipedia (Oct 2013)
  
Can this done using only postgresql and its contrib modules and super simple?
  
NOTES
  
("select word, similarity(word, '$1') AS similarity FROM word_table WHERE word % '$1' ORDER BY similarity DESC", ('foo',))
