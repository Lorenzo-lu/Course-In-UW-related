
## Author Lorenzo Lu
## ylu289@cae.wisc.edu
'''
In this class, you can do naive bayes classification for languages.
By naive bayes, what you have to calculate is this with greatest
p(\hat y|x)
= p(x|y) * p(y) / p(x)
= [p(x_1|y) * p(x_2|y) * ... * p(x_k|y)]  * p(y);

NOTICE: The the add_1 smooth and log10 likelihood are adopted here.


0. In function __init__:
- the "theta" input is the features, or x
- the "prior" input is the priors, or y

1. In function Load_data:
- "pathname" is the directory of txt files
- "filename" is a LIST contains the names of training files
- it will generate a training features as a dictionary:
  the keys are the y, and each key yi has an np.array storing the
  log10 probability log(p(x|yi))
- call class.train to see the log(p(x|y))
- call class.prior_cts to see the log(p(y)) in an np.array

2. In function Counting_theta:
- return the counts of each xi in either training cases or testing
cases

3. In function getDistribution:
- return the log10 probability after add-1 smooth and normalization

4. In function Add_1_smooth:
- return the probability from the counts of xi or "theta"

5. In function Load_test:
- get the counts (not the distribution) of xi
- again, the filename is a LIST so it can process multiple files
at the same time

6. In the function classify:
- get the log likelihood, or log10(p(x|yi)), by calculating the
sum of xi * p(xi|yi)
- get the log posterior, or log10(p(yi|x)), by calcualting the
log10(p(x|yi)) + log10(p(yi))
- return log likelihood and log posterior

7. In the function Pred:
- call class.likelihood to see the log likelihood of all the test
cases in the list "filename"
- call class.posterior to see the log posterior of all the test
cases in the list "filename"
- call the class.pred_list to see the index of predicted \hat y
among all the y classes
- call the class.pred_label to see exactly which class in training
set the training cases matches best.

Function 8-11 are just for homework specific use.


 
'''


import numpy as np;
import matplotlib as plt;
import pandas as pd;


class Naive_Bayes:
    def __init__(self, theta, prior):
        ## theta is the dictionary; so is prior
        self.theta = theta;
        self.theta_len = len(theta);
        
        self.prior = prior;
        self.prior_len = len(prior);
        self.train = {}; ## for counting the freq
        for i in prior:
            self.train[i] = np.array([0] * self.theta_len); # now it is an array, but finally will convert to a list
        self.prior_cts = np.array([0] * self.prior_len);
    
    #---------------------------------------------------------------------------------------
    # set training
    # 1.
    def Load_data(self,pathname, filename):
        text_len = {};
        # this record the total length of the training texts in all the priors
        for i in self.prior:
            text_len[i] = 0;
        
        for i in range(len(filename)):
            ## count the freq of prior            
            label = filename[i][0]; ## it is 'e' 'j' 's' in this case
            
            full_name = pathname + filename[i] + ".txt"
            filetest = open(full_name,"r");
            text = filetest.read();
            filetest.close();
            
            cts = self.Counting_theta(text); # this is a list
            text_len[label] += len(text);
            #text_len[label] += sum(cts);
            
            self.train[label] = (self.train[label]) + np.array(cts); 
            ## convert to array first and do the vectorization calculation    
            
        for label in self.train:
            self.train[label] = self.getDistribution(self.train[label],text_len[label],self.theta_len); 
        
        ## save the prior in self.prior_cts
        r = 0;
        for i in self.train:
            self.prior_cts[r] = len(self.train[i]) / len(filename);
            r += 1;
            
        self.prior_cts = self.getDistribution(self.prior_cts, len(filename), (self.prior_len));        
      
    # 2.    
    # return a list counts the number of features
    def Counting_theta(self, text):
        cts = [0] * (self.theta_len);
        for j in text:
            if j in self.theta:
                cts[self.theta[j]] += 1;  
            #if j == '\n':
                #cts[26] += 1;
        return cts;
    # 3.            
    def getDistribution(self,cts, N, V):
        #cts = self.Counting_theta(text);
        #cts = self.Add_1_Smooth(cts,len(text),len(self.theta));        
        cts = self.Add_1_Smooth(cts,N,V);
        cts /= np.sum(cts); ## normalize
        
        cts = np.log10(cts); ## out as log        
        
        return cts;
        
    # 4.    
    def Add_1_Smooth(self,Cws,N,V):
        ## Cws is the count of the word w
        ## N is total number of words
        ## V is the vocabulary size (distinct words)
        
        return ((Cws + 1) / (N + V)); 
    
    # test
    #---------------------------------------------------------------------------------------
    # 5
    def Load_test(self,pathname,filename):
        # filename is a list, thus it can deal with multiple files at the same time
        self.test_cts = [0] * (len(filename));
        for i in range(len(filename)):
            ## count the freq of prior            
            #label = filename[i][0];
            
            full_name = pathname + filename[i] + ".txt"
            filetest = open(full_name,"r");
            text = filetest.read();
            filetest.close();
            
            self.test_cts[i] = self.Counting_theta(text);  
            self.test_cts[i] = np.array(self.test_cts[i]);
            # the counts of test case
    
    # 6        
    # this function calculate the "likelihood and posterior" of a single test case 
    def Classify(self,cts):
        posterior = [0] * self.prior_len;
        likelihood = [0] * self.prior_len;
        
        def getProb(cts,theta):                        
            return cts.dot(theta);
        
        r = 0; ## r is the r_th language, 
        for i in self.train: ## i is exactly the language, 's' 'j' 'e' in this case
            likelihood[r] = getProb(cts, self.train[i]);
            posterior[r] = likelihood[r] + (self.prior_cts[r]);
            r += 1;        
            
        return [likelihood, posterior];   # pred[i] means the log likelihood of the i_th language
    
    # 7 
    # using 6
    # filename is a list, thus it will deal with a series of files and return their likelihood and posterior as a list
    def Pred(self,pathname,filename):        
        result = [];
        for i in self.prior:
            result.append(i);
        self.Load_test(pathname,filename);       
        
        self.likelihood = [0] * len(filename); ## this is p(x|y)
        self.posterior = [0] * len(filename);  ## this is p(x|y) * p(y) = p(y|x);
        self.pred_list = [0] * len(filename);  ## this is the index of y
        self.pred_label = [0] * len(filename); ## this is the name of this y
        for i in range(len(filename)):
            [like, post] = self.Classify(self.test_cts[i]); 
            self.likelihood[i] = like;
            self.posterior[i] = post;
            self.pred_list[i] = post.index(max(post));
            self.pred_label[i] = result[self.pred_list[i]];
    #---------------------------------------------------------------------------------------        
    # 8        
    def Bag_of_words(self,counts): ## counting the frequency of each char for a testing case
        vector = {};
        r = 0;        
        for i in self.theta:
            vector[i] = counts[r];
            r += 1;
        print(vector);
    
    #---------------------------------------------------------------------------------------
    # 9 
    ## this is used to get the confusion matrix
    ## only when you know the true labels of the test cases!!!
    def Confusion_matrix(self, filename):
        y_true =[];
        for i in filename:
            label = i[0];
            y_true.append(self.prior[label]);
            
        rank = self.prior_len;
        mat = np.zeros((rank,rank));
        for i in range(len(y_true)):
            mat[self.pred_list[i],y_true[i]] += 1;
        
        mat = mat.astype(int);        
        labels = [];
        for i in self.prior: ## making dataframe
            labels.append(i);
        
        frame = {};
        for i in range(self.prior_len):
            series = pd.Series(mat[:,i], index = labels);
            frame[labels[i]] = series;
        
        df = pd.DataFrame(frame);        
        return df;
            
            
    #---------------------------------------------------------------------------------------
    # 10    
    def Text_shuffle(self,text):
        text =list(text);
        return ''.join(np.random.shuffle(text));
    #---------------------------------------------------------------------------------------
    # 11
    ## prepare WEKA text files
    def Weka_prep(self,pathname_read,filename,pathname_save):
        def writeFile(fname, content):
            f = open(fname, 'w');
            f.write(content);
            f.close()
        
        def Space(text):
            text = list(text);            
            for i in range(len(text)):                
                if text[i] == ' ':
                    text[i] = 'space';
            return ' '.join(text);
        
        for i in range(len(filename)):        
            label = filename[i][0];
            
            full_name = pathname_read + filename[i] + ".txt"
            filetest = open(full_name,"r");
            text = filetest.read();
            filetest.close();
            
            text = Space(text);
            
            full_name = pathname_save + label + '/' + filename[i][1:] + ".txt";
            writeFile(full_name, text);
            
        print("Weka prepared!");
