word-prediction-api
===================

Experimental Project
  
self-contained word prediction and correction api built on corpus extracted from Wikipedia (Oct 2013)
  
Can this done using only postgresql and its contrib modules and super simple?
  
NOTES
  
select word, similarity(word, 'lehw') AS similarity FROM word_table WHERE word % 'lehw' ORDER BY similarity DESC;
