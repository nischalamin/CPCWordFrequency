# CPCWordFrequency
Script and R code to perform word frequency analysis for a given CPC class

Features:
COMPLETE - 1 - Ability to enter a CPC Group Symbol, and retrieve a recent set of issued patents classified under that symbol - this is performed by the scrapemergeCPC.rb script, which takes as command line arg the CPC subclass and maingroup as arg #1, and then the group symbol as arg #2. For example, you would call the ruby script with arguments as follows:
> ruby scrapemergeCPC.rb H04B10 70

The above example will obtain all issued patents under the H04B10/70 CPC group symbol, and create a text file, patentnums.txt where each line lists one patent number from the returned set.

2 - The script then extracts the text from the returned patent numbers that are classified under the give cpc group symbol, and outputs this bulk text into a big text file. Google patents will be invoked for extracting the patent text from the patent numbers. Google patent URL is: https://patents.google.com/ Use Mechanize to fill out the form since Google patents uses the doc type in the result URL, and the doc type is not captured in the PatFT scraped listing from step #1.

3 - The script then executes R (or R can do a system call out to run the scraping script) and follows these steps to perform the word frequency analysis: https://deltadna.com/blog/text-mining-in-r-for-term-frequency/
