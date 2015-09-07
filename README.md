# CPCWordFrequency
Script and R code to perform word frequency analysis for a given CPC class

Features:
1 - Ability to enter a CPC Group Symbol, and retrieve a recent set of issued patents classified under that symbol.
2 - The script could pull the data from PatFT - example query for CPC group symbol H04B7/0413: http://patft.uspto.gov/netacgi/nph-Parser?Sect1=PTO2&Sect2=HITOFF&u=%2Fnetahtml%2FPTO%2Fsearch-adv.htm&r=0&p=1&f=S&l=50&Query=CPC%2FH04B7%2F0413&d=PTXT
3 - The script then extracts the text from a subset of the returned patent numbers that are classified under the give cpc group symbol, and outputs this bulk text into a big text file.
4 - The script then executes R (or R can do a system call out to run the scraping script) and follows these steps to perform the word frequency analysis: https://deltadna.com/blog/text-mining-in-r-for-term-frequency/
